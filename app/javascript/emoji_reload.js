$(document).ready(function(){
    $("a.emoji-link").click( function(){
        var url = this.href;
        $("body").load(url);
        return false;
    })
})