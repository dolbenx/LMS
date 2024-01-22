let mobile_url = '/pbs/payments/mobile-money'
let response_url ='/pbs/payments/response?reference='
$(document).ajaxStop($.unblockUI);
$(document).ready(function () {
    // stop ajax call
    // $(document).ajaxStop($.unblockUI);

    function proceed_to_payment(mobile, form, e){
        e.preventDefault()
        let amount = document.getElementById('amount').value;
        let reference = document.getElementById('paymentReference').value;
        Swal.fire({
            title: 'Are you sure you?',
            text: "You won't be able to reverse this action!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: '#23b05d',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes!',
            showLoaderOnConfirm: true
        }).then((result) => {
            if (result.value) {
                $('#card_payments_modal').modal('hide')
                $.ajax({
                    url: mobile_url,
                    type: 'POST',
                    data: {
                        _csrf_token: document.getElementById('csrf').value,
                        mobile: mobile,
                        amount: amount,
                        form: form,
                        reference: reference,
                    },
                    success: function(result) {
                        if (result.status === 0){
                            Swal.fire(
                                'Success',
                                result.message,
                                'success'
                            ).then(() => {
                                window.location.href = response_url+result.ref;
                            });
                        } else {
                            if (counter != 0){
                                Swal.fire({
                                    title: 'Transaction Failed due to: '+ result.message +'?',
                                    text: 'you have '+ counter + ' trie(s)! ',
                                    type: "error",
                                    showCancelButton: true,
                                    confirmButtonColor: '#23b05d',
                                    cancelButtonColor: '#d33',
                                    cancelButtonText: 'Retry Transaction!',
                                    confirmButtonText: 'Back to Home page!',
                                    showLoaderOnConfirm: true
                                }).then((result) => {
                                    if (result.value === true){
                                        window.location.href = '/pbs/payments/response?reference='+document.getElementById('paymentReference').value;
                                        // redirect(document.getElementById('redirectUrl').value, result.method, parseFloat(document.getElementById('amount').value).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,'), document.getElementById('paymentReference').value, "F")
                                        // window.location.replace(document.getElementById('redirectUrl').value+'&paymentReference='+ document.getElementById('paymentReference').value+'&amount='+ parseFloat(document.getElementById('amount').value).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') +'&paymentStatus='+'F');
                                    } else{
                                        counter = counter - 1
                                        attempts = attempts + 1
                                    }
                                });
                            } else{
                                // redirect(document.getElementById('redirectUrl').value, result.method, parseFloat(document.getElementById('amount').value).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,'), document.getElementById('paymentReference').value, "F")
                                window.location.href = '/cbs/init-payment/confirmation/failure?reference='+document.getElementById('paymentReference').value;
                            }

                        }
                    },
                    error: function(request, msg, error) {
                        Swal.fire(
                            'Oops..',
                            'Something went wrong! Retry Transaction',
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
    }

    $('#mtn_mobile_money').submit(function(e){
        e.preventDefault()
        let mtn_mobile_number = document.getElementById('mtn_mobile_number').value;
        let form = document.getElementById('mtn_form').value;
        proceed_to_payment(mtn_mobile_number, form, e)
    });



})


function mobile_money_selector (text) {
    let num = document.getElementById('mobile_money_number').value;
    let  amount = document.getElementById('amount').value;
    let  ref = document.getElementById('reference_number').value;
    if (text === 1){
        zamtel_payments(event, validate_mobile_number(num), amount, ref)
    } else if (text === 2){
        document.getElementById('momo_text_changer').innerHTML = `Enter Your M-Pesa Phone Number`;
    }
}


function validate_mobile_number (num) {
    if (num.startsWith("26", 0)){
        return num
    } else {
        return "26".concat(num)
    }
}

function zamtel_payments (e, mobile, amount, ref) {
    e.preventDefault()
    Swal.fire({
        title: 'Confirm Payment of: ZMW' + amount + ' from Mobile: ' + mobile + '?',
        text: "Please note that a Push Notification will be sent to your Mobile number, Enter mobile Money Pin to Confirm Payment!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Confirm',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.blockUI({ message: `
                 <div class="wrapper_loader2">
                   <img class="image_properties" src="/loader_new/load.png" alt="" style="height: 35px; width: 35px;">
                    <div class="probase_loader_wrapper" style="margin-top:-40px;">
                         <div>
                            <p class="probase_loader_paragraph" style="height: 120px; width: 120px;">Confirm Your Mobile Money Pin Sent to Your Phone </p>
                        </div>
                    </div>
                </div>
            ` });
            $.ajax({
                url: '/pbs/payments/mobile-money',
                type: 'POST',
                data: {
                    _csrf_token: document.getElementById('csrf').value,
                    form: 'XffsvKmVzVSHpqRjWQCTcDBpbjZfxkDKVEjPdYbAxSusPgwTEtTEdySfTRcg',
                    mobile: mobile,
                    paymentReference: ref,
                    amount: amount,
                },
                success: function (result) {
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            window.location.href = '/pbs/payments/response?reference=' + ref;
                        });
                    } else {
                        if (counter != 0){
                            Swal.fire({
                                title: 'Transaction Failed due to: '+ result.message +'?',
                                text: 'you have '+ counter + ' trie(s)! ',
                                type: "error",
                                showCancelButton: false,
                                confirmButtonColor: '#23b05d',
                                cancelButtonColor: '#d33',
                                confirmButtonText: 'Retry Transaction!',
                                showLoaderOnConfirm: true
                            }).then((result) => {
                                if (attempts > 2){
                                    window.location.href = '/pbs/payments/response?reference=' + ref;
                                } else{
                                    counter = counter - 1
                                    attempts = attempts + 1
                                    location.reload()
                                }
                            });
                        } else{
                            window.location.href = '/pbs/payments/response?reference=' + ref;
                        }

                    }
                },
                error: function (request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        'Something went wrong! Retry Transaction',
                        'error'
                    ).then(() => {
                        location.reload()
                    });
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
}