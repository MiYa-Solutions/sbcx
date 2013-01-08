$.rails.href = function (element) {
    return element.data('href') || element.attr('href');
}
$('[type="submit"]').button();


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
