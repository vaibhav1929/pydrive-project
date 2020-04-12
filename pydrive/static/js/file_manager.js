let csrfToken = null;
let userId = null;

const Toast = Swal.mixin({
          toast: true,
          position: 'bottom-end',
          showConfirmButton: false,
          timer: 3000,
          timerProgressBar: true,
          onOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer)
            toast.addEventListener('mouseleave', Swal.resumeTimer)
          }
});

function loadFiles(userid,token, only_starred,folder_id){
    csrfToken = token;
    userId = userid;
    $.ajax({
        url: "file_provider/",
        type: "post",
        data: {'user_id':userid, 'hidden':"",'folder_id':folder_id},
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
            showFiles(data,only_starred);
            loadFolders(userid,csrfToken,only_starred,true,folder_id);
        }
    });
}
function showFiles(data, only_starred, is_option=true) {
    console.log("SHOW FILE:"+is_option);
    let container = document.getElementById("files-container");
    container.innerHTML = "";
    let file_card = document.createElement("div");
    file_card.classList.add("col-md-2","m-2","text-center","p-0","rounded");
    if(only_starred){
        let temp = Array.from(data);
        data = Array();
        for(let i = 0; i < temp.length; i++){
            if(temp[i].file_starred){
                data.push(temp[i]);
            }
        }
    }

    for(let i = 0; i < data.length; i++){
        let fileExtension = data[i].file_title.substr((data[i].file_title.lastIndexOf('.') + 1)).toUpperCase();

        let tempCard = file_card.cloneNode(true);
        tempCard.classList.add("bg-light");
        let filename = document.createElement("div");
        filename.classList.add("font-weight-bold",'bg-info','text-white','p-2','notch');
        filename.innerText = data[i].file_title.length > 20? data[i].file_title.substring(0,15)+"...": data[i].file_title;

        let filedate = document.createElement("div");
        filedate.classList.add("text-muted",'p-1','d-flex','justify-content-between');
        filedate.innerHTML = "<span class='text-left badge badge-secondary'> <i class='fas fa-calendar-check text-light'></i>&nbsp"+data[i].upload_date+"</span><span class='text-right badge badge-secondary'> <i class='fas fa-archive text-light'></i>&nbsp"+bytesToSize(parseInt(data[i].file_size))+"</span>";

        tempCard.id = "file-card-" +i;
        let element = null;
        if(Array("JPEG","PNG","JPG","GIF","TIFF","BMP","APNG","SVG","WEBP").includes(fileExtension)){
            element = document.createElement("img");
            element.height = 128;
            element.style.objectFit = "cover";

        }
        else if(Array("MP4","OGV","WEBM","MKV").includes(fileExtension)){
            element = document.createElement("video");
            element.height = 123;
            element.controls = true;
        }

        if(element != null){
            element.src = data[i].file_link;
            element.classList.add("w-100");
            tempCard.appendChild(element);
            tempCard.appendChild(filename);
            tempCard.appendChild(filedate);
            addOptions(data[i],tempCard,i,is_option);
            container.appendChild(tempCard);
        }
        else{
            d3.xml("../static/img/file_bg.svg", "image/svg+xml", function(xml) {
                let importedNode = document.importNode(xml.documentElement, true);
                importedNode.classList.add("col");
                importedNode.getElementById("ext-text").textContent = fileExtension;
                tempCard.appendChild(importedNode);
                if(Array("MP3","WAV","OGG").includes(fileExtension)){
                    importedNode.style.height = "83px";
                    element = document.createElement("audio");
                    element.controls = true;
                    element.src = data[i].file_link;
                    element.classList.add("w-100");
                    element.style.height = "40px";
                    tempCard.appendChild(element);
                }
                tempCard.appendChild(filename);
                tempCard.appendChild(filedate);
                addOptions(data[i],tempCard,i,is_option);
                container.appendChild(tempCard);
            });
        }


    }
    //file_card.remove();
}

function addOptions(data, fileCard, i, is_option) {
    console.log("ADD OPTION:"+is_option);
    let optionsCard = document.createElement("div");
    optionsCard.id = "options-"+i;
    optionsCard.classList.add("w-100");
    if(is_option){
        let shareBtn = document.createElement("button");
        shareBtn.classList.add("btn","col-md-4","bg-light","rounded-0","m-0");
        shareBtn.innerHTML = "<i class='fas fa-share-alt text-success'></i>";
        shareBtn.setAttribute("data-toggle","modal");
        shareBtn.setAttribute("data-target","#shareModal");
        shareBtn.setAttribute("data-extra",data.id);
        shareBtn.setAttribute("data-is_folder",0);

        let starBtn = document.createElement("button");
        starBtn.classList.add("btn","col-md-4","bg-light","rounded-0","m-0");
        if(data.file_starred){
            starBtn.innerHTML = "<i class='fas fa-star text-warning'></i>";
        }
        else{
            starBtn.innerHTML = "<i class='fas fa-star text-info'></i>";
        }
        starBtn.onclick = function(){
          toggle_star({'user_id':data.user_id,'file_id':data.id}, starBtn);
        };

        let deleteBtn = document.createElement("button");
        deleteBtn.classList.add("btn","col-md-4","bg-light","rounded-0","m-0");
        deleteBtn.innerHTML = "<i class='fas fa-trash text-danger'></i>";
        deleteBtn.onclick = function(){
            Swal.fire({
              title: 'Are you sure?',
              text: "You won't be able to revert this!",
              icon: 'warning',
              showCancelButton: true,
              confirmButtonColor: '#3085d6',
              cancelButtonColor: '#cacaca',
              confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
              if (result.value) {
                Swal.fire(
                  'Deleted!',
                  'Your file has been deleted.',
                  'success'
                );
                deleteFile({'user_id':data.user_id,'file_id':data.id, 'file_link':data.file_link.substring(1)}, fileCard);
              }
            });

        };
        optionsCard.appendChild(shareBtn);
        optionsCard.appendChild(starBtn);
        optionsCard.appendChild(deleteBtn);

    }

    let downloadBtn = document.createElement("a");
    downloadBtn.download = true;
    downloadBtn.href = "http://localhost:8000/file_download?era="+data.file_link.substring(1)+"&iera="+data.user_id;
    downloadBtn.classList.add("btn","col-md-12","bg-dark","rounded-0","m-0");
    downloadBtn.innerHTML = "<i class='fas fa-download text-white'></i>";

    optionsCard.appendChild(downloadBtn);

    fileCard.appendChild(optionsCard);
}

function loadFolders(userid,token,only_starred,is_option=true,parent=null) {
    let sendData = {'user_id':userid};
    if(parent != null){
        sendData.parent_id = parent;
    }
    $.ajax({
        url: "folder_provider/",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': token}, // for csrf token
        success: function(data) {
            if(only_starred){
                for(let i = 0; i < data.length; i++){
                    let temp = Array.from(data);
                    data = Array();
                    for(let i = 0; i < temp.length; i++){
                        if(temp[i].folder_starred){
                            data.push(temp[i]);
                        }
                    }
                }
            }
            showFolders(data,is_option);
        }
    });
}

function setFolderOptions(userid,container) {
$.ajax({
        url: "folder_provider/",
        type: "post",
        data: {'user_id':userid,'show_nested':true},
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
                container.innerHTML = "";
                let defaultOp = document.createElement("option");
                defaultOp.innerText = "Select Folder";
                defaultOp.value = "";
                container.appendChild(defaultOp);

                for(i = 0; i < data.length; i++){
                    let option = document.createElement("option");
                    let viewName = data[i].folder_link.substring(10).substring( data[i].folder_link.substring(10).indexOf("/")+1);
                    option.innerText = viewName;
                    option.value = data[i].id;
                    container.appendChild(option);
                }
        }
    });
}
function showFolders(data,is_option) {
    let folderContainer = document.getElementById("folder-container");
    folderContainer.innerHTML = "";
    for(i = 0; i < data.length; i++){
                let row = document.createElement("tr");
                let folderId = document.createElement("input");
                folderId.type = "hidden";
                folderId.readOnly = true;
                folderId.value = data[i].id;

                let folderIndexId = document.createElement("td");
                let folderName = document.createElement("td");
                let folderDate = document.createElement("td");

                let optionCol = document.createElement("td");

                if(is_option){
                    //---STAR FOLDER-------------------------------------------------------------
                    let starBtn = document.createElement("button");
                    let starBtnHandler = function(row_data){

                        return function () {starFolder(row_data.user_id, row_data.id,starBtn);};
                    };
                    starBtn.onclick = starBtnHandler(data[i]);
                    starBtn.classList.add("btn","btn-info","m-2");
                    if(data[i].folder_starred)
                        starBtn.innerHTML = "<i class='fas fa-star text-warning'></i>";
                    else
                        starBtn.innerHTML = "<i class='fas fa-star text-white'></i>";
                    optionCol.appendChild(starBtn);

                    //---SHARE FOLDER--------------------------------------------------------------
                    let shareBtn = document.createElement("button");
                     let shareBtnhandler = function(row_data){
                        return function () { shareFolder(row_data.user_id,row_data.folder_link,row_data.id,row); }
                    };
                    shareBtn.onclick = shareBtnhandler(data[i]);
                    shareBtn.classList.add("btn","btn-success","m-2");
                    shareBtn.innerHTML = "<i class='fas fa-share text-white'></i>";
                    shareBtn.setAttribute("data-toggle","modal");
                    shareBtn.setAttribute("data-target","#shareModal");
                    shareBtn.setAttribute("data-extra",data[i].id);
                    shareBtn.setAttribute("data-is_folder",1);
                    optionCol.appendChild(shareBtn);

                    //---DELETE FOLDER-------------------------------------------------------------
                    let deleteBtn = document.createElement("button");
                    let deleteBtnhandler = function(row_data){
                        return function () { deleteFolder(row_data.user_id,row_data.folder_link,row_data.id,row); }
                    };
                    deleteBtn.onclick = deleteBtnhandler(data[i]);
                    deleteBtn.classList.add("btn","btn-danger","m-2");
                    deleteBtn.innerHTML = "<i class='fas fa-trash text-white'></i>";
                    optionCol.appendChild(deleteBtn);
                }

                //---DOWNLOAD FOLDER-----------------------------------------------------------
                let downloadBtn = document.createElement("a");
                downloadBtn.href = "http://localhost:8000/folder_download?era="+data[i].folder_link+"&iera="+data[i].user_id;

                downloadBtn.classList.add("btn","bg-dark","m-2");
                downloadBtn.innerHTML = "<i class='fas fa-download text-white'></i>";
                optionCol.appendChild(downloadBtn);


                folderIndexId.innerText = i+1;
                folderName.innerText = data[i].folder_name;
                folderDate.innerText = data[i].folder_date;
                row.appendChild(folderId);
                row.appendChild(folderIndexId);
                row.appendChild(folderName);
                row.appendChild(folderDate);
                row.appendChild(optionCol);

                let clickHandler = function(row_data){
                    return function () {
                        if(is_option)
                            window.location.href = ("http://localhost:8000/dashboard?folder_id="+row_data.id);
                        else
                            window.location.href = ("http://localhost:8000/shared?folder_id="+row_data.id);
                    }
                };
                folderName.style.cursor = "pointer";
                folderName.onclick = clickHandler(data[i]);
                folderContainer.appendChild(row);
    }
}


function deleteFile(sendData,element) {
    $.ajax({
        url: "delete",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
             if(data.Status){
                element.remove();
            }
            else{
                alert("Not able to delete! try again!");
            }
        }
    });
}


function toggle_star(sendData,element) {
    $.ajax({
        url: "toggle_star",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
             if(data.Status){
                element.innerHTML = "<i class='fas fa-star text-warning'></i>";
                Toast.fire({
                      icon: 'success',
                      title: 'File starred successfully'
                });

            }
            else{
                element.innerHTML = "<i class='fas fa-star text-info'></i>";

                Toast.fire({
                  icon: 'success',
                  title: 'File removed from starred successfully'
                });
            }
        }
    });
}

function saveFolder(userid) {
    $.ajax({
        url:"save_folder",
        type:"post",
        data:{'user_id':userid, 'folder_name':document.getElementById("foldernamebox").value, 'parent_id':document.getElementById("folderOptions2").value},
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success:function (data) {
            if(data.status){
                Toast.fire({
                      icon: 'success',
                      title: 'Folder created successfully'
                });
                loadFolders(userid,csrfToken);
            }
            else{
                Toast.fire({
                      icon: 'warning',
                      title: 'Error occurred!'
                });
            }
        }

    })
}

function starFolder(userId,folderId,element) {
    sendData = {'user_id':userId,'folder_id':folderId};
    console.log(sendData);
$.ajax({
        url: "toggle_folder_star",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
             if(data.Status){
                element.innerHTML = "<i class='fas fa-star text-warning'></i>";
                Toast.fire({
                      icon: 'success',
                      title: 'Folder starred successfully'
                });

            }
            else{
                element.innerHTML = "<i class='fas fa-star text-white'></i>";

                Toast.fire({
                  icon: 'success',
                  background:'#ffcbb0',
                  title: 'Folder removed from starred successfully'
                });
            }
        }
    });
}

function deleteFolder(userId,folder_link,folderId,element) {
    sendData = {'user_id':userId, 'folder_link':folder_link, 'folder_id':folderId};
    Swal.fire({
          title: 'Are you sure?',
          text: "You won't be able to revert this!",
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#cacaca',
          confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
          if (result.value) {
            Swal.fire(
              'Deleted!',
              'Your file has been deleted.',
              'success'
            );
             $.ajax({
                url: "delete_folder",
                type: "post",
                data: sendData,
                headers: {'X-CSRFToken': csrfToken}, // for csrf token
                success: function(data) {
                     if(data.Status){
                        element.remove();
                    }
                    else{
                        alert("Not able to delete! try again!");
                    }
                }
            });
          }
        });
}

// Helper functions ========================================================================================================
function bytesToSize(bytes) {
   var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
   if (bytes === 0) return '0 Byte';
   var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
   return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
}

function forgotPassword(csrf_Token){
    $.ajax({
        url:'forgot_password',
        type:'post',
        data:{'email':document.getElementById("pswemailbox").value},
        headers:{'X-CSRFToken':csrf_Token},
        success:function (data) {
            Toast.fire({icon:'info',title:"Rest email is sent, (if you are registered)"})
        }
    })
}
