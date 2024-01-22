$('#example1 tbody').on('click', '.approve-holiday', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Holiday?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/admin/change/management/approve/holiday',
                type: 'POST',
                data: { id: button.attr("data-holiday-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            location.reload();

                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        ).then((_) => {
                            location.reload();
                        });
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                }
            });
        } else {
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })

});


$('#example1 tbody').on('click', '.delete-holiday', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Delete Holiday?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/admin/change/management/delete/holiday',
                type: 'POST',
                data: { id: button.attr("data-holiday-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            location.reload();

                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        ).then((_) => {
                            location.reload();
                        });
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                }
            });
        } else {
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })

});