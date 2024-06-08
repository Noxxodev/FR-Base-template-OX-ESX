$(function(){
    window.addEventListener('message', function(event){
        var item = event.data;
        $('#hp-text').text(item.hp);
        $('#hp-bar').css("width", `${item.hp}%`)
        $('#ar-text').text(item.ar);
        $('#ar-bar').css("width", `${item.ar}%`)
        if(item.ar == 0){
            $('#ar').hide()
        } else {
            $('#ar').fadeIn()
        }
        $('#th-text').text(`${item.th.toFixed(0)}/100`);
        $('#hg-text').text(`${item.hg.toFixed(0)}/100`);
        $('#plcount').text(`${item.pcount}/64`);
    })
})