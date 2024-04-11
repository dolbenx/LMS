$('.logSign button').on('click', function()
{
  $('.logSign button').removeClass('active');
  $(this).addClass('active');
  if ($('#showlogin').hasClass('active'))
  {
      $('main .signup-form').css('display', 'none');
      $('main .login-form').css('display', 'block');

  }
  else
  {
      $('main .signup-form').css('display', 'block');
      $('main .login-form').css('display', 'none');
  }
})


$(document).ready(function()
{
  setTimeout(function()
  {
    $("form .input-field").each(function()
    {
      $(this).addClass('reveal');
    })
  }, 1000)

})








// disable on enter
$('form').on('keyup keypress', function(e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode === 13) { 
      e.preventDefault();
      return false;
    }
  });




  // form validiation
  var inputschecked = false;


  function formvalidate(stepnumber)
  {
    // check if the required fields are empty
    inputvalue = $("#step"+stepnumber+" :input").not("button").map(function()
    {
      if(this.value.length > 0)
      {
        $(this).removeClass('invalid');
        return true;
  
      }
      else
      {
        
        if($(this).prop('required'))
        {
          $(this).addClass('invalid');
          return false
        }
        else
        {
          return true;
        }
        
      }
    }).get();
    
  
    // console.log(inputvalue);
  
    inputschecked = inputvalue.every(Boolean);
  
    // console.log(inputschecked);
  }


$(document).ready(function()
  {

    //email validiation

    var email = $('#mail-email').val();
    var re = /^\w+([-+.'][^\s]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
    var emailFormat = re.test(email);

    $('.login').on('click', function()
    {

      formvalidate(1);
                
        
      if(inputschecked == false)
      {
          formvalidate(1);
      }
    })
    $('.signup').on('click', function()
    {

      formvalidate(2);
                
        
      if(inputschecked == false)
      {
          formvalidate(2);
      }
    })
   }
   );































