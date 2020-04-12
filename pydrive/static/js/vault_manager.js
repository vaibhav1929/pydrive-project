async function authVault(userId,Token) {
    const {value: password} = await Swal.fire({
        title: 'Enter your password:',
        input: 'password',
        inputPlaceholder: 'Enter your password',
        inputAttributes: {
            maxlength: 10,
            autocapitalize: 'off',
            autocorrect: 'off'
        }
    });
    if (password) {
        csrfToken = Token;
        sendData = {'user_id':userId, 'password':password};
        $.ajax({
        url: "auth_vault",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: async function (data) {
            if (data.Status) {
                loadHFiles(userId,csrfToken);
            } else {
                await Swal.fire({
                  icon: 'error',
                  title: 'Authentication Failed!',
                  text: 'Wrong password',
                });
                authVault(userId, csrfToken);
            }
        }
        });
    }
}

function loadHDbleFiles(userId,csrfToken) {

    $.ajax({
        url: "file_provider/",
        type: "post",
        data: {'user_id':userId,'hidden':""},
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
            document.getElementById("HDBle-body").innerHTML = "";
            for(i = 0; i < data.length; i++){
                let row = document.createElement("tr");

                let fileId = document.createElement("input");
                fileId.type = "hidden";
                fileId.readOnly = true;
                fileId.value = data[i].id;

                let fileIndexId = document.createElement("td");
                let fileName = document.createElement("td");
                let fileDate = document.createElement("td");
                let hideCol = document.createElement("td");
                let hideBtn = document.createElement("button");
                hideBtn.onclick = function(){
                  toggleHideFile(userId,fileId.value,csrfToken);
                };
                hideBtn.classList.add("btn","btn-dark");
                hideBtn.innerHTML = "<i class='fas fa-eye-slash text-white'></i>";
                hideCol.appendChild(hideBtn);

                fileIndexId.innerText = i+1;
                fileName.innerText = data[i].file_title;
                fileDate.innerText = data[i].upload_date;

                row.appendChild(fileId);
                row.appendChild(fileIndexId);
                row.appendChild(fileName);
                row.appendChild(fileDate);
                row.appendChild(hideCol);
                document.getElementById("HDBle-body").appendChild(row);
            }
        }
    });
}
function loadHFiles(userId,csrfToken) {

    sendData = {'user_id':userId, 'hidden':true};
        $.ajax({
        url: "file_provider/",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: async function (data) {
            if(data.length === 0){
                let container = document.getElementById("hidden-container");
                badge = document.createElement("span");
                badge.classList.add("col-md-6","badge", "badge-dark", "text-white");
                badge.style.fontSize = "30px";
                badge.innerHTML = "<i class='fas fa-eye-slash text-white'></i> No hidden Files!";
                container.appendChild(badge);
            }
            else{
                showFiles(data);
            }
             loadHDbleFiles(userId,csrfToken);
        }
      });
}
function showFiles(data) {
    let container = document.getElementById("hidden-container");
    container.innerHTML = "";
    let file_card = document.createElement("div");
    file_card.classList.add("col-md-2","m-2","text-center","p-0","rounded");

    for(let i = 0; i < data.length; i++){
        let fileExtension = data[i].file_title.substr((data[i].file_title.lastIndexOf('.') + 1)).toUpperCase();

        let tempCard = file_card.cloneNode(true);
        tempCard.classList.add("bg-dark");
        let filename = document.createElement("div");
        filename.classList.add("font-weight-bold",'bg-info','text-white','p-2','notch');
        filename.innerText = data[i].file_title.length > 25? data[i].file_title.substring(0,20)+"...": data[i].file_title;

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
            addOptions(data[i],tempCard,i);
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
                addOptions(data[i],tempCard,i);
                container.appendChild(tempCard);
            });
        }


    }
    file_card.remove();
}

function addOptions(data,fileCard,i) {
    let optionsCard = document.createElement("div");
    optionsCard.id = "options-"+i;
    optionsCard.classList.add("w-100");

    let unhideBtn = document.createElement("button");
    unhideBtn.classList.add("btn","col-md-4","bg-dark","rounded-0","m-0");
    unhideBtn.innerHTML = "<i class='fas fa-eye text-success'></i>";
    unhideBtn.onclick = function(){
        toggleHideFile(data.user_id, data.id, csrfToken);
    };

    let deleteBtn = document.createElement("button");
    deleteBtn.classList.add("btn","col-md-4","bg-dark","rounded-0","m-0");
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

    let downloadBtn = document.createElement("a");
    downloadBtn.download = true;
    downloadBtn.href = "http://localhost:8000/file_download?era="+data.file_link.substring(1)+"&iera="+data.user_id;
    downloadBtn.classList.add("btn","col-md-4","bg-dark","rounded-0","m-0");
    downloadBtn.innerHTML = "<i class='fas fa-download text-info'></i>";

    optionsCard.appendChild(unhideBtn);
    optionsCard.appendChild(deleteBtn);
    optionsCard.appendChild(downloadBtn);

    fileCard.appendChild(optionsCard);
}


function toggleHideFile(userId, fileId, csrfToken) {
    console.log("UID:"+userId+",FID:"+fileId);
    $.ajax({
        url: "toggle_hide",
        type: "post",
        data: {'user_id':userId,'file_id':fileId},
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
             if(data.Status){
               // element.innerHTML = "<i class='fas fa-star text-warning'></i>";
                Toast.fire({
                      icon: 'success',
                      title: 'File hidden'
                });
            }
            else{
            //    element.innerHTML = "<i class='fas fa-star text-info'></i>";

                Toast.fire({
                  icon: 'success',
                  background:'#ffd5d5',
                  title: 'File is removed from vault'
                });
            }
            loadHFiles(userId,csrfToken);
        }
    });
}

function bytesToSize(bytes) {
   var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
   if (bytes === 0) return '0 Byte';
   var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
   return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
}