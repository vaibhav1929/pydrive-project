import os
import random
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from io import BytesIO
from datetime import date
import shutil
from django.contrib import messages
from django.http import HttpResponseRedirect, HttpResponse, FileResponse
from django.shortcuts import render, redirect
from django.http import JsonResponse
from app.models import user, verification, files, folder, shared
import smtplib
import zipfile
import hashlib
from django.core.files.storage import default_storage


def home(request):
    if request.session and request.session.__contains__('user_id'):
        return redirect('dashboard')
    return render(request, 'index.html')


def dashboard(request):
    if 'user_id' in request.session.keys() and request.session['user_id'] is not None:
        if request.GET and request.GET.__contains__('starred'):
            return render(request, 'dashboard.html', {'starred': True})
        if request.GET and request.GET.__contains__('folder_id'):
            return render(request, 'dashboard.html', {'folder_id': request.GET['folder_id']})
        return render(request, 'dashboard.html')
    return redirect('index')


def get_entry(request):
    page_name = 'index'
    if request.POST and request.POST['submit'] == 'Login':
        page_name = login(request)
    else:
        page_name = signup(request)
    return redirect(page_name)


def test(req):
    return render(req, 'test.html')


def login(request):
    # check if verified
    # maintain session

    if request.POST is not None and request.POST['email'] is not None and request.POST['password'] is not None:
        try:
            tempuser = user.objects.get(user_email=request.POST['email'])
        except user.DoesNotExist:
            tempuser = None

        if tempuser is None:
            messages.error(request, message="User not exists!")
            return 'index'
        else:
            password = request.POST['password']
            hashed = hashlib.md5(password.encode())
            password = hashed.hexdigest()
            if str(password) == str(tempuser.user_password):
                try:
                    verified = verification.objects.get(user_id=tempuser.id)
                except verification.DoesNotExist:
                    verified = None

                if verified is None:
                    request.session['user_id'] = tempuser.id
                    request.session['user_email'] = tempuser.user_email
                    return 'dashboard'
                else:
                    return 'verify'
            else:
                messages.error(request, message="Wrong password!")
                return 'index'
    else:
        return 'index'


def logout(request):
    del request.session['user_id']
    del request.session['user_email']
    return redirect('index')


def signup(request):
    # send verification.(records in user table and verification table)
    print("SIGNUP")
    if request.POST is not None and request.POST['email'] is not None and request.POST['password'] is not None:
        mail = request.POST['email']
        password = request.POST['password']

        try:
            tempuser = user.objects.get(user_email=mail)
        except user.DoesNotExist:
            tempuser = None

        if tempuser is not None:
            messages.error(request, message="User already exists!")
            return 'index'

        hashed = hashlib.md5(password.encode())
        password = hashed.hexdigest()

        tempuser = user(user_email=mail, user_password=password)
        tempuser.save()
        otp = random.randint(100000, 999999)
        verificationRecord = verification(user_id=tempuser.id, otp=otp)
        verificationRecord.save()
        send_email(mail, "OTP", 'Here is your one time verification code:<h4>' + str(otp) + "</h4>")
        return 'verify'
    return 'index'


def verify(request):
    return render(request, 'verify.html')


def validate_otp(request):
    tempuser = user.objects.get(user_email=request.POST['email_field'])
    verified = verification.objects.get(user_id=tempuser.id)
    if verified is not None:
        if int(verified.otp) == int(request.POST['otp_field']):
            verified.delete()
            request.session['user_id'] = tempuser.id
            request.session['user_email'] = tempuser.user_email
            os.mkdir('user_data/' + str(tempuser.id))
            return redirect('dashboard')
        else:
            return render(request, 'verify.html')
    else:
        return redirect('index')


def save_folder(request):
    print(request.POST)
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.POST['user_id']):
        if len(request.POST['parent_id']) == 0:
            parentId = None
            link = 'user_data/' + request.POST['user_id'] + '/' + request.POST['folder_name']
            os.mkdir(link)
        else:
            parentId = request.POST['parent_id']
            parent = folder.objects.get(id=parentId)
            link = parent.folder_link + "/" + request.POST['folder_name']
            os.mkdir(link)

        folder(folder_name=request.POST['folder_name'],
               folder_link=str(link),
               folder_date=date.today(),
               folder_starred=False,
               parent_id=parentId,
               user_id=int(request.POST['user_id'])
               ).save()
        return JsonResponse({'status': True})
    return JsonResponse({'status': False})


def upload_files(request):
    print(request.POST)
    files = request.FILES.getlist('file_input')
    handle_uploaded_file(files, request)
    return HttpResponse("{}")


def handle_uploaded_file(f, request):
    userid = str(request.session['user_id'])
    parentPath = userid + "/"
    folderId = None
    if len(request.POST['parent_id']) > 0:
        folderId = int(request.POST['parent_id'])
        parentPath = folder.objects.get(id=folderId).folder_link + "/"
        parentPath = parentPath[10:]

    for tempF in f:
        file_name = default_storage.save(parentPath + tempF.name, tempF)
        file_url = default_storage.url(file_name)

        fi = files(user_id=userid,
                   folder_id=folderId,
                   file_title=tempF.name,
                   file_size=str(default_storage.open(file_name).size),
                   upload_date=date.today(),
                   file_link=file_url,
                   file_starred=False,
                   file_hidden=False).save()


def file_provider(request):
    if request.POST.__contains__('folder_id') and len(request.POST['folder_id']) > 0:
        data = list(files.objects.filter(user_id=request.POST['user_id'], file_hidden=bool(request.POST['hidden']),
                                         folder_id=request.POST['folder_id']).values())
    else:
        data = list(files.objects.filter(user_id=request.POST['user_id'], file_hidden=bool(request.POST['hidden']),
                                         folder_id=None).values())
    return JsonResponse(data, safe=False)


def folder_provider(request):
    if not request.POST.__contains__('show_nested'):
        if request.POST.__contains__('parent_id'):
            data = list(
                folder.objects.filter(user_id=request.POST['user_id'],
                                      parent_id=int(request.POST['parent_id'])).values()
            )
        else:
            data = list(
                folder.objects.filter(user_id=request.POST['user_id'], parent_id=None).values()
            )
    else:
        if request.POST.__contains__('parent_id'):
            data = list(
                folder.objects.filter(user_id=request.POST['user_id'],
                                      parent_id=int(request.POST['parent_id'])).values()
            )
        else:
            data = list(
                folder.objects.filter(user_id=request.POST['user_id']).values()
            )

    return JsonResponse(data, safe=False)


def file_download(request):
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.GET['iera']):
        file = request.GET['era'].replace("%20", " ")
        response = FileResponse(open(file, 'rb'))
        return response
    return redirect('dashboard')


def toggle_star(request):
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.POST['user_id']):
        obj = files.objects.get(id=int(request.POST['file_id']))
        if obj:
            obj.file_starred = not obj.file_starred
            print(obj.file_starred)
            obj.save()
            return JsonResponse({"Status": obj.file_starred})
    return redirect('dashboard')


def toggle_star_folder(request):
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.POST['user_id']):
        obj = folder.objects.get(id=int(request.POST['folder_id']))
        if obj:
            obj.folder_starred = not obj.folder_starred
            obj.save()
            return JsonResponse({"Status": obj.folder_starred})
    return redirect('dashboard')


def toggle_hide(request):
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.POST['user_id']):
        obj = files.objects.get(id=int(request.POST['file_id']))
        if obj:
            obj.file_hidden = not obj.file_hidden
            obj.save()
            return JsonResponse({"Status": obj.file_hidden})
    return redirect('vault_dashboard')


def delete_file(request):
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.POST['user_id']):
        obj = files.objects.get(id=int(request.POST['file_id']))
        if obj:
            obj.delete()
            os.remove(request.POST['file_link'].replace("%20", " "))
            return JsonResponse({'Status': True})
    return redirect('dashboard')


def delete_folder(request):
    if request.session and request.session.__contains__('user_id') and request.session['user_id'] == int(
            request.POST['user_id']):
        obj = folder.objects.get(id=int(request.POST['folder_id']))
        if obj:
            shutil.rmtree(request.POST['folder_link'].replace("%20", " "))
            obj.delete()
            return JsonResponse({'Status': True})
    return redirect('dashboard')


def download_folder(request):
    zip_io = BytesIO()
    folder = request.GET['era'].replace("%20", " ")
    with zipfile.ZipFile(zip_io, mode='w', compression=zipfile.ZIP_DEFLATED) as backup_zip:

        for roots, dirs, files in os.walk(folder):
            for item in files:
                backup_zip.write(roots + "/" + item)
            if roots == folder:
                continue
            else:
                backup_zip.write(roots)

    response = HttpResponse(zip_io.getvalue(), content_type='application/x-zip-compressed')
    response['Content-Disposition'] = 'attachment; filename=%s' % folder + ".zip"
    response['Content-Length'] = zip_io.tell()
    return response


def get_shared(request):
    obj = shared.objects.filter(file=int(request.POST['file_id']), user_id=int(request.POST['user_id']),
                                is_folder=request.POST['is_folder'])
    userEmails = []
    for share_obj in obj.values():
        data_obj = {'id': share_obj['id'], 'email': user.objects.get(id=share_obj['sharedUser_id']).user_email,
                    'file_id': share_obj['file'], 'sharedUser_id': share_obj['sharedUser_id'],
                    'is_folder': share_obj['is_folder']}
        userEmails.append(data_obj)
    return JsonResponse(userEmails, safe=False)


def check_share(request):
        obj = user.objects.get(user_email=request.POST['share_email'])
        shareRecord = shared.objects.filter(sharedUser_id=obj.id, file=int(request.POST['file_id']),
                                            is_folder=request.POST['is_folder']).count()
        if shareRecord > 0:
            return JsonResponse({'status': False, 'error': "File is already shared with this user!"})
        else:
            savedRecord = shared(user_id=int(request.POST['user_id']), file=int(request.POST['file_id']),
                                 sharedUser_id=obj.id, is_folder=request.POST['is_folder'], date=date.today()).save()
            type = "folder :" + files.objects.get(
                id=request.POST['file_id']).file_title if bool(request.POST['is_folder']) else "file:" + folder.objects.get(
                id=request.POST['file_id']).folder_name
            message = request.session['user_email'] + " shared a <b>" + type + ".</b> \n checkout in the dashboard"
            #send_email(request.POST['share_email'], "Shared", message)
            return JsonResponse({'status': True})


def revoke_share(request):
    shared.objects.get(id=int(request.POST['id'])).delete()
    return JsonResponse({'status': True})


def render_shared(request):
    print(request.GET)
    if 'user_id' in request.session.keys() and request.session['user_id'] is not None:
        if request.GET and request.GET.__contains__('folder_id'):
            return render(request, 'shared.html', {'folder_id': request.GET['folder_id']})
        return render(request, 'shared.html')
    return redirect('index')


def shared_file_provider(request):
    fileObjects = shared.objects.filter(sharedUser_id=request.POST['user_id'], is_folder=0)
    data = list()
    for fileObj in fileObjects.values():
        if request.POST.__contains__('folder_id') and len(request.POST['folder_id']) > 0:
            obj = files.objects.get(id=fileObj['file'], folder_id=request.POST['folder_id'])

        else:
            obj = files.objects.get(id=fileObj['file'])
        temp = obj.__dict__
        del temp['_state']
        data.append(temp)
    print(data)
    return JsonResponse(data, safe=False)


def shared_folder_provider(request):
    folderObjects = shared.objects.filter(sharedUser_id=request.POST['user_id'], is_folder=1)
    data = list()
    for folderObj in folderObjects.values():
        if request.POST.__contains__('parent_id') and len(request.POST['parent_id']) > 0:
            obj = folder.objects.get(id=folderObj['file'], parent_id=request.POST['parent_id'])
        else:
            obj = folder.objects.get(id=folderObj['file'])
        temp = obj.__dict__
        del temp['_state']
        data.append(temp)
    print(data)
    return JsonResponse(data, safe=False)


def vault(request):
    if request.session and request.session.__contains__('user_id'):
        obj = user.objects.get(id=int(request.session['user_id']))
        if obj:
            if obj.user_vault_psw == "":
                return redirect('profile')
    return redirect('vault_dashboard')


def auth_vault(request):
    if request.session and request.session.__contains__('user_id') and request.POST and request.POST.__contains__(
            'user_id') and request.POST.__contains__('password'):
        obj = user.objects.get(id=int(request.session['user_id']))
        if obj:
            hashed = hashlib.md5(request.POST['password'].encode())
            password = hashed.hexdigest()
            if obj.user_vault_psw == password:
                request.session['vault_auth'] = True
                return JsonResponse({'Status': True})
            else:
                return JsonResponse({'Status': False})

    return redirect('dashboard')


def vault_dashboard(request):
    if request.session and request.session.__contains__('user_id'):
        return render(request, 'vault_dashboard.html', {'user_id': request.session['user_id']})
    return redirect('dashboard')


def change_psw(request):
    if request.session and request.session.__contains__('user_id') and request.POST:
        obj = user.objects.get(id=int(request.session['user_id']))
        if obj:
            if request.POST.__contains__('acc_psw') and request.POST['acc_psw']:
                hashed = hashlib.md5(request.POST['acc_psw'].encode())
                password = hashed.hexdigest()
                obj.user_password = password
                obj.save()
                return redirect('profile')
            if request.POST.__contains__('vault_psw') and request.POST['vault_psw']:
                hashed = hashlib.md5(request.POST['vault_psw'].encode())
                password = hashed.hexdigest()
                obj.user_vault_psw = password
                obj.save()
                return redirect('profile')

    return redirect('profile')


def settings(req):
    return render(req, 'profile.html')


def forgot_password(request):
    if user.objects.filter(user_email=request.POST['email']).count() > 0:
        temp_psw = str(random.randint(10000000,99999999))
        hashed = hashlib.md5(temp_psw.encode())
        password = hashed.hexdigest()
        userObj = user.objects.get(user_email=request.POST['email'])
        userObj.user_password = password
        userObj.save()
        send_email(request.POST['email'], "Reset Password", "<b>Your new temporary password is:"+temp_psw+"</b><h4>It is highly recommended to change your password from user profile :)</h4>")
        return JsonResponse({'status':True})
    return JsonResponse({'status':False})


def send_email(mail, subject,temp_message):
    message = MIMEMultipart("Drive")
    message['subject'] = subject
    message['From'] = 'pycloud.app@outlook.com'
    message['To'] = mail
    message.attach(MIMEText(temp_message, 'html'))

    try:
        mail_server = smtplib.SMTP(host="smtp.office365.com", port=587)
        print(mail_server.__dict__)
        mail_server.starttls()
        mail_server.login(user="pycloud.app@outlook.com", password="vy525529")
        mail_server.sendmail("pycloud.app@outlook.com", mail, msg=message.as_string())
        mail_server.quit()
    except Exception as E:
        print(E)
