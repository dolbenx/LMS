"use strict";

// Class definition
var KTWizard3 = function () {
	// Base elements
	var _wizardEl;
	var _formEl;
	var _wizard;
	var _validations = [];

	// Private functions
	var initWizard = function () {
		// Initialize form wizard
		_wizard = new KTWizard(_wizardEl, {
			startStep: 1, // initial active step number
			clickableSteps: true  // allow step clicking
		});

		// Validation before going to next page
		_wizard.on('beforeChange', function (wizard) {
			// Don't go to the next step yet
			_wizard.stop();

			// Validate form
			var validator = _validations[wizard.getStep() - 1]; // get validator for currnt step
			if (validator) {
				validator.validate().then(function (status) {
					if (status == 'Valid') {
						_wizard.goNext();
						KTUtil.scrollTop();
					} else {
						Swal.fire({
							text: "Sorry, looks like you missed some fileds, please try again. You wont be able to go to the next step.",
							icon: "warning",
							buttonsStyling: false,
							confirmButtonText: "Ok, got it!",
							customClass: {
								confirmButton: "btn font-weight-bold btn-light"
							}
						}).then(function () {
							KTUtil.scrollTop();
						});
					}
				});
			}
		});

		// Change event
		_wizard.on('change', function (wizard) {
			KTUtil.scrollTop();
		});
	}

	var initValidation = function () {
		// Init form validation rules. For more info check the FormValidation plugin's official documentation:https://formvalidation.io/
		// Step 1
		_validations.push(FormValidation.formValidation(
			_formEl,
			{
				fields: {
					companyName: {
						validators: {
							notEmpty: {
								message: 'Company name is required'
							}
						}
					},
					companyPhone: {
						validators: {
							notEmpty: {
								message: 'Company mobile No. is required'
							}
						}
					},
					registrationNumber: {
						validators: {
							notEmpty: {
								message: 'Company Registraion No. is required'
							}
						}
					},
					contactEmail: {
						validators: {
							notEmpty: {
								message: 'Company Email is required'
							}
						}
					}
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					bootstrap: new FormValidation.plugins.Bootstrap()
				}
			}
		));

		// Step 2
		_validations.push(FormValidation.formValidation(
			_formEl,
			{
				fields: {
					file: {
						validators: {
							notEmpty: {
								message: 'The documents are required'
							}
						}
					}
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					bootstrap: new FormValidation.plugins.Bootstrap()
				}
			}
		));

		// Step 3
		_validations.push(FormValidation.formValidation(
			_formEl,
			{
				fields: {
					firstName: {
						validators: {
							notEmpty: {
								message: 'First name is required'
							}
						}
					},
					lastName: {
						validators: {
							notEmpty: {
								message: 'Last name is required'
							}
						}
					},
					mobileNumber: {
						validators: {
							notEmpty: {
								message: 'Mobile No. is required'
							}
						}
					},
					emailAddress: {
						validators: {
							notEmpty: {
								message: 'Email address is required'
							}
						}
					},
					meansOfIdentificationNumber: {
						validators: {
							notEmpty: {
								message: 'ID number is required'
							}
						}
					}
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					bootstrap: new FormValidation.plugins.Bootstrap()
				}
			}
		));
	}

	return {
		// public functions
		init: function () {
			_wizardEl = KTUtil.getById('kt_wizard_v3');
			_formEl = KTUtil.getById('kt_form');

			initWizard();
			initValidation();
		}
	};
}();

jQuery(document).ready(function () {
	KTWizard3.init();
});
