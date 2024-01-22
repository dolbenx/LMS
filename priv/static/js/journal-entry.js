$('#select-batch').change(function() {
    batch_id = $(this).find(':selected').attr('data-batch-id');
    $('#selected-batch-id').val(batch_id);
});

("#reload-batch").click(function() {
    location.reload();
})

$("#close-batch").click(function(e) {
    e.preventDefault()
    var btn = $(this);
    var dt = null;
    var dr_cr_diff = document.getElementById("dr_cr_difference").value;
    if (btn.attr("data-dt-type") == "MANUAL") {
        dt = batch_items_dt;
    } else {
        dt = upload_file_dt;
    }
    if (dt.rows().count() <= 0) {
        Swal.fire(
            'Oops..!',
            'No transactions found!',
            'error'
        )
        return false;
    }
    if (dr_cr_diff != 0.0) {
        Swal.fire(
            'Failed..',
            'Total Debits do not match Total Credits !',
            'error'
        )
        return false;
    }
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to reverse this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        closeOnConfirm: false,
        closeOnCancel: false,
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            spinner.show();
            $.ajax({
                url: '/close/batch',
                type: 'POST',
                data: { batch_no: $('.batch-no').val(), batch_id: $('.batch-id').val(), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    spinner.hide();
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        )
                        if (btn.attr("data-dt-type") == "MANUAL") {
                            window.location.replace("/list/jounal/entries");
                        } else {
                            // window.location.replace("/bulk/file/verification");
                        }

                    } else {
                        Swal.fire(
                            'Oops...',
                            result.error,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    spinner.hide();
                    Swal.fire(
                        'Oops...',
                        'Something went wrong! try again',
                        'error'
                    )
                }
            });
        } else {
            spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })
});