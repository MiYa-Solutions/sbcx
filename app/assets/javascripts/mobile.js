$.rails.href = function (element) {
    return element.data('href') || element.attr('href');
}
$('[type="submit"]').button();
