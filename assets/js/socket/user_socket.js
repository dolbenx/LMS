
import {Socket} from "phoenix"
let socket = new Socket("/user_socket", {params: {token: sessionStorage.userToken}})

socket.connect()
let user_id = sessionStorage.userSessionId
if (user_id) {
    let channel = socket.channel("user_session:"+user_id, {}) 
    channel.on("global_export:" + user_id + ":complete", ({ payload, fileName, extension }) => {
        var temp = "data:application/vnd.ms-excel;base64," + encodeURIComponent(payload);
        var download = document.createElement("a");
        download.href = temp;
        download.download = fileName + extension;
        document.body.appendChild(download);
        download.click();
        document.body.removeChild(download);
      });

    channel.join()

    // exports_channel.join()
}

export default socket
