$('document').ready(function() {
    $('#quotation_category').on('change', function () {
        if (this.value != "New Category") {
            $("#post_category_name").prop('disabled', true);
        } else {
            $("#post_category_name").prop('disabled', false);
        }
    });
});