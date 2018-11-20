let draw
let inputs = Array.from(document.getElementsByTagName("input"))
inputs = inputs.concat(Array.from(document.getElementsByTagName("textarea")))

inputs.forEach((input) => {
  input.addEventListener("focus", () => {
    clearInterval(draw)
  })
  input.addEventListener("blur", () => {
    trail()
  })
})

let imgMe = document.getElementsByClassName("img-me")[0]
imgMe.addEventListener("mouseenter", e => {
  clearInterval(draw)
})
imgMe.addEventListener("mouseleave", e => {
  trail()
})

function trail() {
  
  var mousePos = {};

 function getRandomInt(min, max) {
   return Math.round(Math.random() * (max - min + 1)) + min;
 }
  
  $(window).mousemove(function(e) {
    mousePos.x = e.pageX;
    mousePos.y = e.pageY;
  });
  
  $(window).mouseleave(function(e) {
    mousePos.x = -1;
    mousePos.y = -1;
  });
  
  draw = setInterval(function(){
    if(mousePos.x > 0 && mousePos.y > 0){
      
      var range = 15;
      
      var color = "background: rgb("+getRandomInt(0,255)+","+getRandomInt(0,255)+","+getRandomInt(0,255)+");";
      
      var sizeInt = getRandomInt(5, 10);
      size = "height: " + sizeInt + "px; width: " + sizeInt + "px;";
      
      var left = "left: " + getRandomInt(mousePos.x-range-sizeInt, mousePos.x+range) + "px;";
      
      var top = "top: " + getRandomInt(mousePos.y-range-sizeInt, mousePos.y+range) + "px;"; 

      var style = left+top+color+size;
      $("<div class='ball' style='" + style + "'></div>").appendTo('#wrap').one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function(){$(this).remove();}); 
    }
  }, 5);
}

$(document).ready(trail);

document.onscroll = function() {
    if (window.innerHeight + window.scrollY >= document.body.clientHeight) {
        document.getElementById('chevron').style.display='none';
    } else {
        document.getElementById('chevron').style.display='flex';
    }
}

$("#about-contact").click(() => {
	$("#about-me-modal").modal("hide")
})
