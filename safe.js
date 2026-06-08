const Safe = {
    AlertTimeout: null,
    EnteredCode: '',
    ChangeMode: false,
    ChangeStep: null,
    OldCode: null,
    
    Open: function() {
        $('.safe').fadeIn(120);
        currentMenu = 'safe';
    },

    Close: function() {
        $('.safe').fadeOut(120);
        currentMenu = null;
    },

    SetFirstTime: function() {
        this.Open();
        const alert = `<p class="warning">${translation.safe['screen.set_pin']}</p>`;
        
        Safe.ChangeMode = true;
        Safe.OldCode = "";
        Safe.ChangeStep = "enter-new";

        $('.safe .alert > div').html(alert);
    },

    Update: function() {
        const dots = this.EnteredCode.replace(/./g, "•");

        if (this.AlertTimeout) {
            clearTimeout(this.AlertTimeout);
            this.AlertTimeout = null;
        }
        
        $('.safe .alert > div').html(`<p>${dots}</p>`);
    },    

    ShowAlert: function(message, type) {
        const alert = `<p class="${type}">${message}</p>`;
        $('.safe .alert > div').html(alert);
        
        if (this.AlertTimeout) clearTimeout(this.AlertTimeout);
        
        this.AlertTimeout = setTimeout(() => {
            $('.safe .alert > div').html('');
            this.AlertTimeout = null;
        }, 2000);
    },

    ChangedPIN: function(data) {
        if (data.success) {
            this.ShowAlert(translation.safe['screen.pin_changed'], "success");
        }
    }
}

$('.safe .buttons > div').on('click', function () {
    const val = $(this).text();
    if (val === "C") {
        Safe.EnteredCode = "";
        Safe.Update();
    } else if (val === "E") {
        if (Safe.ChangeMode) {
            if (Safe.ChangeStep === 'verify-old') {
                $.post(`https://${GetParentResourceName()}/safe:verifyCode`, JSON.stringify({
                    code: Safe.EnteredCode,
                    isChanging: true
                }), function(success) {
                    if (success) {
                        Safe.Update();
                        Safe.ShowAlert(translation.safe['screen.enter_new_pin'], "warning");
                        Safe.ChangeStep = 'enter-new';
                        Safe.OldCode = Safe.EnteredCode;
                        Safe.EnteredCode = "";
                    } else {
                        Safe.Update();
                        Safe.ShowAlert(translation.safe['screen.wrong_code'], "error");
                        Safe.EnteredCode = "";
                        Safe.ChangeMode = false;
                        Safe.ChangeStep = null;
                    }
                });
            }
    
            else if (Safe.ChangeStep === 'enter-new') {
                if (Safe.EnteredCode.length < 4) {
                    Safe.ShowAlert(translation.safe['screen.pin_too_short'], "error");
                    return;
                }

                $.post(`https://${GetParentResourceName()}/safe:changeCode`, JSON.stringify({
                    oldCode: Safe.OldCode,
                    newCode: Safe.EnteredCode
                }));
    
                Safe.EnteredCode = "";
                Safe.ChangeMode = false;
                Safe.ChangeStep = null;
            }
    
        } else {
            $.post(`https://${GetParentResourceName()}/safe:verifyCode`, JSON.stringify({
                code: Safe.EnteredCode
            }), function(success) {
                if (success) {
                    Safe.ShowAlert(translation.safe['screen.access_granted'], "success");
                    setTimeout(() => {
                        Safe.Close();
                    }, 1200);
                } else {
                    Safe.ShowAlert(translation.safe['screen.wrong_code'], "error");
                }
            });
            Safe.EnteredCode = "";
        }
    } else {
        if (Safe.EnteredCode.length < 8) {
            Safe.EnteredCode += val;
            Safe.Update();
        }
    }
});

$('.safe .safe-actions > #changePinBtn').on('click', function () {
    Safe.ChangeMode = true;
    Safe.ChangeStep = 'verify-old';
    Safe.EnteredCode = "";
    Safe.Update();
    Safe.ShowAlert(translation.safe['screen.enter_current_pin'], "warning");
});
