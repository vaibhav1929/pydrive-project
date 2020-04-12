let shareFileId = null;
let is_folder = 0;
$(document).ready(function () {
$("#shareModal").on('show.bs.modal', function(event){
    var btn = $(event.relatedTarget);
    let id = btn.data("extra");
    is_folder = btn.data('is_folder');
    shareFileId = id;
    setSharingData();
  });
});
function setSharingData() {
$.ajax({
       url:"get_shared",
       type:"post",
       data:{'user_id':userId, 'file_id':shareFileId, 'is_folder':is_folder},
       headers:{'x-CSRFToken':csrfToken},
       success: function (data) {
           let container =  document.getElementById("shared-container");
           container.innerHTML = "";
            for(let i = 0; i < data.length; i++){
                let row = document.createElement("tr");
                let idCol = document.createElement("td");
                let emailCol = document.createElement("td");
                let actionCol = document.createElement("td");
                emailCol.innerText = data[i].email;
                actionCol.innerText = "X";
                let revokeHandler = function(row_data){
                    return function () {revokeShare(row_data);}
                };
                actionCol.onclick = revokeHandler(data[i]);

                idCol.innerText = ""+i+1;
                actionCol.id = data[i].id;
                actionCol.style.cursor = "pointer";
                let shareActionHandler = function (row_data) {
                    return function () {revokeShare(row_data);}
                };
                actionCol.onclick = shareActionHandler(data[i]);
                row.appendChild(idCol);
                row.appendChild(emailCol);
                row.appendChild(actionCol);
                container.appendChild(row);
            }
       }
    });
}
function revokeShare(row_data) {
    $.ajax({
        url:'revoke_share',
        type: 'post',
        data: {'id':row_data.id},
        headers:{'X-CSRFToken':csrfToken},
        success:function (data) {
            if(data.status){
                Toast.fire({title:"sharing is revoked"});
                setSharingData();
            }
            else{
                Toast.fire({title:"Error Occured."+data.error})
            }
        }
    })
}
function checkAndShare() {
    email = document.getElementById("share_emailbox").value;
    $.ajax({
        url:'check_share',
        type: 'post',
        data: {'user_id':userId, 'file_id':shareFileId, 'share_email':email, 'is_folder':is_folder},
        headers:{'X-CSRFToken':csrfToken},
        success:function (data) {
            if(data.status){
                Toast.fire({title:"File shared with "+email});
                setSharingData();
            }
            else{
                Toast.fire({title:"Error Occured."+data.error})
            }
        }

    })
}
function shareFolder(folderId) {
    shareFileId = folderId;
    is_folder = 1;
}

function loadSharedFiles(userid,token,folder_id){
    csrfToken = token;
    userId = userid;
    $.ajax({
        url: "shared_file_provider",
        type: "post",
        data: {'user_id':userid,'folder_id':folder_id},
        headers: {'X-CSRFToken': csrfToken}, // for csrf token
        success: function(data) {
            showFiles(data,false,false);
            loadSharedFolders(userid,csrfToken,folder_id);
        }
    });
}
function loadSharedFolders(userid,token,parent=null) {
    let sendData = {'user_id':userid};
    if(parent != null){
        sendData.parent_id = parent;
    }
    $.ajax({
        url: "shared_folder_provider",
        type: "post",
        data: sendData,
        headers: {'X-CSRFToken': token}, // for csrf token
        success: function(data) {
            showFolders(data,false);
        }
    });
}
