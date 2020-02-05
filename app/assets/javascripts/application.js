// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require Chart.min

// アバター変更の際の画像プレビュー
$(function() {
  function readURL(input) {
    if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('#avatar-prev').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
    }
  }
  $("#avatar-edit-field").change(function(){
    $('#avatar-prev').removeClass('hidden');
    $('#avatar-present').remove();
    readURL(this);
  });
});

$(function() {
  // コメント機能
  // formがからの時は投稿できない。
  $(document).on("click", "input[type=submit]", function() {
    if ($("textarea").val() == "") {
      return false;
    }
  });

  // コメントの投稿
  $(document).on("ajax:success", ".comment-ajax", function(e) {
    // comment form-fieldの記入をリセット
    $(".comment-text-area").val("");
    // comment areaの先頭に挿入
    $(".show-comment-area").prepend(
      "<div><p>" +
        e.detail[0][1] +
        "</p>" +
        "<p>" +
        e.detail[0][0] +
        "</p></div>"
    );
  });
});