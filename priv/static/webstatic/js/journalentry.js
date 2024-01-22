$('#close-batch').click(function(e) {
    e.preventDefault()
    Swal.fire({
        title: 'Are you sure you want to Close Batch?',
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
                url: '/close/batch',
                type: 'POST',
                data: { batch_no: $('.batch-no').val(), batch_id: $('.batch-id').val(), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            // location.reload();
                            window.location.replace("/jounal/entry");
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


$('#cancle-batch').click(function(e) {
    e.preventDefault()
    Swal.fire({
        title: 'Are you sure you want to Discard Batch?',
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
                url: '/cancle/batch',
                type: 'POST',
                data: { batch_no: $('.batch-no').val(), batch_id: $('.batch-id').val(), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            // location.reload();
                            window.location.replace("/jounal/entry");
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

var spinner = $('#loader');
batch_id = null;
user_id = null;
batch_no = null;
$('#last_batch_usr').change(function() {
    batch_id = ($(this).val());
    spinner.show();
    $.ajax({
        url: '/last/batch/usr/lookup',
        type: 'POST',
        data: { batch_id: batch_id, _csrf_token: $('#csrf').val() },
        success: function(result) {
            spinner.hide();
            if (result.data) {
                batch_id = result.data.id;
                user_id = result.data.last_user_id;
                $('#last-user').val(result.data.firstName + ' ' + result.data.lastName);
                Swal.fire(
                    'Great',
                    'User retrieved',
                    'success'
                )
            } else {
                Swal.fire(
                    'Oops',
                    'Something went wrong!',
                    'error'
                )
            }
        },
        error: function(request, msg, error) {
            spinner.hide();
            Swal.fire(
                'Oops',
                'Something went wrong! try again',
                'error'
            )
        }
    });
});

$('#authorize-batch').click(function(e) {
    e.preventDefault()
    Swal.fire({
        title: 'Are you sure you want to Approve Batch?',
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
                url: '/authorize/batch',
                type: 'POST',
                data: { batch_id: $('.batch-id').val(), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            // location.reload();
                            window.location.replace("/authorised/jounal/entries/batch");
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


$('#discard-batch').click(function(e) {
    e.preventDefault()
    Swal.fire({
        title: 'Are you sure you want to Discard Batch?',
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
                url: '/discard/batch',
                type: 'POST',
                data: { batch_no: $('.batch-no').val(), batch_id: $('.batch-id').val(), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            // location.reload();
                            window.location.replace("/authorised/jounal/entries/batch");
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

$("#reload-batch").click(function() {
    location.reload();
})