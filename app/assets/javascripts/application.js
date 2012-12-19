// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require autocomplete-rails
//= require bootstrap
//= require jquery.purr
//= require best_in_place
//= require best_in_place.purr
//= require bootstrap-datepicker
//= require_tree .


$(function () {
    $(".datepicker").datepicker({ dateFormat:"yy-mm-dd" });
});


$(function () {
    $(".datepicker2").datepicker({
        changeMonth:true,
        changeYear:true
    });
});


$(".collapse").collapse('toggle');


$(function () {
    $('.accordion .head').click(function () {
        $(this).next().toggle('slow');
        return false;
    }).next().hide();
});

$('.typeahead').typeahead();

$(".tooltip").tooltip();
$("a[rel=tooltip]").tooltip();


$('.popover').popover();


$(function () {
    $('.i').scroller({
        preset:'date',
        invalid:{ daysOfWeek:[0, 6], daysOfMonth:['5/1', '12/24', '12/25'] },
        theme:'default',
        display:'inline',
        mode:'scroller',
        dateOrder:'mmD ddyy'
    });
});

