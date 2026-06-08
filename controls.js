function ControlsMenu(data) {
    if (data.toggle) {
        if (data.controlsName) {
            let controlsHTML = '';
            controlsHTML += `<div class="label">${translation.controls_menu[data.controlsLabel]}</div>`;

            const controlsList = config.controlsList[data.controlsName] || {};
            const entries = Object.entries(controlsList);
            entries.forEach(([_, value], index) => {
                if (index > 0) {
                    controlsHTML += '<hr>';
                }
                controlsHTML += `
                    <div><span class="key">${value.control}</span>${value.label}</div>
                `;
            });
            
            $('.controls-menu > .controls').html(controlsHTML);
        }
        $('.controls-menu').fadeIn(80);
    } else {
        $('.controls-menu').fadeOut(80);
    }
}