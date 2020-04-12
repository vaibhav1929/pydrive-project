from django.db import models


# Create your models here.
class user(models.Model):
    user_email = models.TextField()
    user_password = models.TextField()
    user_vault_psw = models.TextField()

class verification(models.Model):
    user = models.ForeignKey('user', on_delete=models.CASCADE)
    otp = models.IntegerField()


class files(models.Model):
    user = models.ForeignKey('user', on_delete=models.CASCADE)
    folder = models.ForeignKey('folder', on_delete=models.CASCADE, default=0)
    file_title = models.TextField()
    file_size = models.TextField()
    upload_date = models.DateField()
    file_hidden = models.BooleanField()
    file_link = models.TextField()
    file_starred = models.BooleanField()


class shared(models.Model):
    user = models.ForeignKey('user', on_delete=models.CASCADE, related_name='owner')
    sharedUser = models.ForeignKey('user', on_delete=models.CASCADE, related_name='share_holder')
    file = models.IntegerField()
    date = models.DateField()
    is_folder = models.BooleanField(default=False)


class folder(models.Model):

    user = models.ForeignKey('user', on_delete=models.CASCADE)
    folder_name = models.TextField()
    folder_date = models.DateField()
    folder_starred = models.BooleanField()
    folder_link = models.TextField()
    parent = models.ForeignKey('folder', on_delete=models.CASCADE)