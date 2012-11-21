// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){

  if($("#content-editor").length > 0){
    var target = $("#content-editor");
    var broswe = $("#content-editor").attr("data-broswe");
    var upload = $("#content-editor").attr("data-upload");
    CKEDITOR.replace('content-editor', {
      filebrowserBrowseUrl : broswe,
      filebrowserUploadUrl : upload,
      filebrowserWindowWidth : '640',
      filebrowserWindowHeight : '480'
    });
  }

  if($("#excerpt-editor").length > 0){
    var target = $("#excerpt-editor");
    var broswe = $("#excerpt-editor").attr("data-broswe");
    var upload = $("#excerpt-editor").attr("data-upload");
    CKEDITOR.replace('excerpt-editor', {
      filebrowserBrowseUrl : broswe,
      filebrowserUploadUrl : upload,
      filebrowserWindowWidth : '640',
      filebrowserWindowHeight : '480'
    });
  }

});