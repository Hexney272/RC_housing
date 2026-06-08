function formatNumber(value, min, max) {
    return new Intl.NumberFormat('en-US', {
        minimumFractionDigits: min,
        maximumFractionDigits: max
    }).format(value);
}

String.prototype.format = function () {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{' + i + '\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

function getCurrentPeriod() {
    const now = new Date();
    return `${String(now.getMonth() + 1).padStart(2, '0')}:${now.getFullYear()}`;
}

function formatPeriod(input) {
    if (input.startsWith('W')) {
        const [weekPart, yearStr] = input.split(':');
        const weekNumber = parseInt(weekPart.slice(1), 10);
        const year = parseInt(yearStr, 10);
        return (translation.manage.bills['period.weekly']).format(weekNumber, year);
    } else {
        const [monthStr, yearStr] = input.split(':');
        const month = parseInt(monthStr, 10) - 1;
        const year = parseInt(yearStr, 10);

        const date = new Date(year, month);
        return date.toLocaleString('en-US', { month: 'long', year: 'numeric' });
    }
}

function isNumberKey(evt) {
    var charCode = evt.which ? evt.which : evt.keyCode;
    if (
        charCode == 8 ||
        charCode == 46 ||
        charCode == 37 ||
        charCode == 39
    ) return true;

    if (
        (charCode < 48 || charCode > 57) &&
        (charCode < 96 || charCode > 105)
    ) {
        evt.preventDefault();
        return false;
    }
    return true;
};

const loadTranslation = () => {
    // Creator Menu:
    $('.housing_creator ul.side-bar > #general > span').text(translation.creator.side_menu['section:general']);
    $('.housing_creator ul.side-bar > li[data-href="new"] > p.label').text(translation.creator.side_menu['option:create']);
    $('.housing_creator ul.side-bar > li[data-href="all-properties"] > p.label').text(translation.creator.side_menu['option:all_properties']);
    $('.housing_creator ul.side-bar > li[data-href="all-furniture"] > p.label').text(translation.creator.side_menu['option:all_furniture']);
    $('.housing_creator .menu > #register-new-furniture > div > .header').text(translation.creator.register_new_furniture['header:title']);
    $('.housing_creator .menu > #register-new-furniture > div > .description > div > label > label').text(translation.creator.register_new_furniture['header:buttons:check_existing']);
    $('.housing_creator .menu > #register-new-furniture > div > .buttons > div').text(translation.creator.register_new_furniture['header:buttons:save']);
    $('.housing_creator .main > div[data-type="new"] .text > div > .header').text(translation.creator.new_property['header:subtitle']);
    $('.housing_creator .main > div[data-type="new"] .text > div > .title').text(translation.creator.new_property['header:title']);
    $('.housing_creator .main > div[data-type="new"] #housing_types > div[data-housing-type="shell"] > p').text(translation.creator.new_property['type:shell']);
    $('.housing_creator .main > div[data-type="new"] #housing_types > div[data-housing-type="ipl"] > p').text(translation.creator.new_property['type:ipl']);
    $('.housing_creator .main > div[data-type="new"] #housing_types > div[data-housing-type="mlo"] > p').text(translation.creator.new_property['type:mlo']);
    $('.housing_creator .main > div[data-type="new"] #housing_types > div[data-housing-type="building"] > p').text(translation.creator.new_property['type:building']);
    $('.housing_creator .main > div[data-type="new"] #housing_types > div[data-housing-type="motel"] > p').text(translation.creator.new_property['type:motel']);
    $('.housing_creator .main > div[data-type="new-shell"] .text > div > .header').text(translation.creator.new_shell['header:subtitle']);
    $('.housing_creator .main > div[data-type="new-shell"] .text > div > .title').text(translation.creator.new_shell['header:title']);
    $('.housing_creator .main > div[data-type="new-shell"] .text > div > .tags > span').text(translation.creator.new_shell['header:filters']);
    $('.housing_creator .main > div[data-type="new-ipl"] .text > div > .header').text(translation.creator.new_ipl['header:subtitle']);
    $('.housing_creator .main > div[data-type="new-ipl"] .text > div > .title').text(translation.creator.new_ipl['header:title']);
    $('.housing_creator .main > div[data-type="new-ipl"] .text > div > .tags > span').text(translation.creator.new_ipl['header:filters']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .text > div > .header').text(translation.creator.configuration_shell['header:subtitle']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .text > div > .title').text(translation.creator.configuration_shell['header:title']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .text > .buttons > .button.save').text(translation.creator.configuration_shell['header:buttons:save']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .text > .buttons > .button.delete').text(translation.creator.configuration_shell['header:buttons:delete']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-building"]').text(translation.creator.configuration_shell['option:label.building']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-motel"]').text(translation.creator.configuration_shell['option:label.motel']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-address"]').text(translation.creator.configuration_shell['option:label.address']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-region"]').text(translation.creator.configuration_shell['option:label.region']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-house_name"]').text(translation.creator.configuration_shell['option:label.house_name']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-house_description"]').text(translation.creator.configuration_shell['option:label.house_description']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-purchase_price"]').text(translation.creator.configuration_shell['option:label.purchase_price']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-rent_price"]').text(translation.creator.configuration_shell['option:label.rent_price']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-name"]').text(translation.creator.configuration_shell['option:label.interior_name']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-yard_zone"]').text(translation.creator.configuration_shell['option:label.yard_zone']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-enter_point"]').text(translation.creator.configuration_shell['option:label.enter_point']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-exit_point"]').text(translation.creator.configuration_shell['option:label.exit_point']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-emergency_exit"]').text(translation.creator.configuration_shell['option:label.emergency_exit']);
    
    tippy('.housing_creator .main > div[data-type="configuration-shell"] .options div[data-button-action="shell-emergency_exit_outside"]', {
        content: translation.creator.configuration_shell['option:tooltip.emergency_exit_outside'],
        animation: 'scale-extreme',
        maxWidth: 150,
        delay: 0,
        placement: 'top',
        moveTransition: 'transform 0.2s ease-out',
    });

    tippy('.housing_creator .main > div[data-type="configuration-shell"] .options div[data-button-action="shell-emergency_exit_inside"]', {
        content: translation.creator.configuration_shell['option:tooltip.emergency_exit_inside'],
        animation: 'scale-extreme',
        maxWidth: 150,
        delay: 0,
        placement: 'top',
        moveTransition: 'transform 0.2s ease-out',
    });

    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-__garage"]').text(translation.creator.configuration_shell['option:label.garage']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-__parking"]').text(translation.creator.configuration_shell['option:label.parking']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-delivery"]').text(translation.creator.configuration_shell['option:label.delivery']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-delivery_inside"]').text(translation.creator.configuration_shell['option:label.delivery_inside']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-delivery_outside"]').text(translation.creator.configuration_shell['option:label.delivery_outside']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-furniture_environment"]').text(translation.creator.configuration_shell['option:label.furniture_environment']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-furniture_environment_inside"]').text(translation.creator.configuration_shell['option:label.furniture_environment_inside']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-furniture_environment_outside"]').text(translation.creator.configuration_shell['option:label.furniture_environment_outside']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-wardrobe"]').text(translation.creator.configuration_shell['option:label.wardrobe']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-storage"]').text(translation.creator.configuration_shell['option:label.storage']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-keys_limit"]').text(translation.creator.configuration_shell['option:label.keys_limit']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-permissions_limit"]').text(translation.creator.configuration_shell['option:label.permissions_limit']);
    $('.housing_creator .main > div[data-type="configuration-shell"] .options label.input-name[for="shell-parking_space"]').text(translation.creator.configuration_shell['option:label.parking_space']);


    $('.housing_creator .main > div[data-type="configuration-ipl"] .text > div > .header').text(translation.creator.configuration_ipl['header:subtitle']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .text > div > .title').text(translation.creator.configuration_ipl['header:title']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .text > .buttons > .button.save').text(translation.creator.configuration_ipl['header:buttons:save']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .text > .buttons > .button.delete').text(translation.creator.configuration_ipl['header:buttons:delete']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-building"]').text(translation.creator.configuration_ipl['option:label.building']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-motel"]').text(translation.creator.configuration_ipl['option:label.motel']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-address"]').text(translation.creator.configuration_ipl['option:label.address']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-region"]').text(translation.creator.configuration_ipl['option:label.region']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-house_name"]').text(translation.creator.configuration_ipl['option:label.house_name']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-house_description"]').text(translation.creator.configuration_ipl['option:label.house_description']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-purchase_price"]').text(translation.creator.configuration_ipl['option:label.purchase_price']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-rent_price"]').text(translation.creator.configuration_ipl['option:label.rent_price']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-name"]').text(translation.creator.configuration_ipl['option:label.interior_name']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-theme"]').text(translation.creator.configuration_ipl['option:label.interior_theme']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-__theme_purchase_change"]').text(translation.creator.configuration_ipl['option:label.interior_theme_purchase_change']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-__theme_purchased_change"]').text(translation.creator.configuration_ipl['option:label.interior_theme_purchased_change']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-yard_zone"]').text(translation.creator.configuration_ipl['option:label.yard_zone']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-enter_point"]').text(translation.creator.configuration_ipl['option:label.enter_point']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-exit_point"]').text(translation.creator.configuration_ipl['option:label.exit_point']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-emergency_exit"]').text(translation.creator.configuration_ipl['option:label.emergency_exit']);
    
    tippy('.housing_creator .main > div[data-type="configuration-ipl"] .options div[data-button-action="ipl-emergency_exit_outside"]', {
        content: translation.creator.configuration_ipl['option:tooltip.emergency_exit_outside'],
        animation: 'scale-extreme',
        maxWidth: 150,
        delay: 0,
        placement: 'top',
        moveTransition: 'transform 0.2s ease-out',
    });

    tippy('.housing_creator .main > div[data-type="configuration-ipl"] .options div[data-button-action="ipl-emergency_exit_inside"]', {
        content: translation.creator.configuration_ipl['option:tooltip.emergency_exit_inside'],
        animation: 'scale-extreme',
        maxWidth: 150,
        delay: 0,
        placement: 'top',
        moveTransition: 'transform 0.2s ease-out',
    });
    
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-__garage"]').text(translation.creator.configuration_ipl['option:label.garage']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-__parking"]').text(translation.creator.configuration_ipl['option:label.parking']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-delivery"]').text(translation.creator.configuration_ipl['option:label.delivery']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-delivery_inside"]').text(translation.creator.configuration_ipl['option:label.delivery_inside']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-delivery_outside"]').text(translation.creator.configuration_ipl['option:label.delivery_outside']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-furniture_environment"]').text(translation.creator.configuration_ipl['option:label.furniture_environment']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-furniture_environment_inside"]').text(translation.creator.configuration_ipl['option:label.furniture_environment_inside']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-furniture_environment_outside"]').text(translation.creator.configuration_ipl['option:label.furniture_environment_outside']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-wardrobe"]').text(translation.creator.configuration_ipl['option:label.wardrobe']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-storage"]').text(translation.creator.configuration_ipl['option:label.storage']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-keys_limit"]').text(translation.creator.configuration_ipl['option:label.keys_limit']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-permissions_limit"]').text(translation.creator.configuration_ipl['option:label.permissions_limit']);
    $('.housing_creator .main > div[data-type="configuration-ipl"] .options label.input-name[for="ipl-parking_space"]').text(translation.creator.configuration_ipl['option:label.parking_space']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .text > div > .header').text(translation.creator.configuration_mlo['header:subtitle']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .text > div > .title').text(translation.creator.configuration_mlo['header:title']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .text > .buttons > .button.save').text(translation.creator.configuration_mlo['header:buttons:save']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .text > .buttons > .button.delete').text(translation.creator.configuration_mlo['header:buttons:delete']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-motel"]').text(translation.creator.configuration_mlo['option:label.motel']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-address"]').text(translation.creator.configuration_mlo['option:label.address']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-region"]').text(translation.creator.configuration_mlo['option:label.region']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-house_name"]').text(translation.creator.configuration_mlo['option:label.house_name']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-house_description"]').text(translation.creator.configuration_mlo['option:label.house_description']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-purchase_price"]').text(translation.creator.configuration_mlo['option:label.purchase_price']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-rent_price"]').text(translation.creator.configuration_mlo['option:label.rent_price']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-yard_zone"]').text(translation.creator.configuration_mlo['option:label.yard_zone']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-interior_zone"]').text(translation.creator.configuration_mlo['option:label.interior_zone']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-menu_point"]').text(translation.creator.configuration_mlo['option:label.menu_point']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-__garage"]').text(translation.creator.configuration_mlo['option:label.garage']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-__parking"]').text(translation.creator.configuration_mlo['option:label.parking']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-delivery"]').text(translation.creator.configuration_mlo['option:label.delivery']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-delivery_inside"]').text(translation.creator.configuration_mlo['option:label.delivery_inside']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-delivery_outside"]').text(translation.creator.configuration_mlo['option:label.delivery_outside']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-doors"]').text(translation.creator.configuration_mlo['option:label.doors']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-add_single_doors"]').text(translation.creator.configuration_mlo['option:button.doors_add_single']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-add_double_doors"]').text(translation.creator.configuration_mlo['option:button.doors_add_double']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-add_slide_gate"]').text(translation.creator.configuration_mlo['option:button.add_slide_gate']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-furniture_environment"]').text(translation.creator.configuration_mlo['option:label.furniture_environment']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-furniture_environment_inside"]').text(translation.creator.configuration_mlo['option:label.furniture_environment_inside']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-furniture_environment_outside"]').text(translation.creator.configuration_mlo['option:label.furniture_environment_outside']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-wardrobe"]').text(translation.creator.configuration_mlo['option:label.wardrobe']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-storage"]').text(translation.creator.configuration_mlo['option:label.storage']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-keys_limit"]').text(translation.creator.configuration_mlo['option:label.keys_limit']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-permissions_limit"]').text(translation.creator.configuration_mlo['option:label.permissions_limit']);
    $('.housing_creator .main > div[data-type="configuration-mlo"] .options label.input-name[for="mlo-parking_space"]').text(translation.creator.configuration_mlo['option:label.parking_space']);
    $('.housing_creator .main > div[data-type="configuration-building"] .text > div > .header').text(translation.creator.configuration_building['header:subtitle']);
    $('.housing_creator .main > div[data-type="configuration-building"] .text > div > .title').text(translation.creator.configuration_building['header:title']);
    $('.housing_creator .main > div[data-type="configuration-building"] .text > .buttons > .button.save').text(translation.creator.configuration_building['header:buttons:save']);
    $('.housing_creator .main > div[data-type="configuration-building"] .text > .buttons > .button.delete').text(translation.creator.configuration_building['header:buttons:delete']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-address"]').text(translation.creator.configuration_building['option:label.address']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-region"]').text(translation.creator.configuration_building['option:label.region']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-name"]').text(translation.creator.configuration_building['option:label.building_name']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-yard_zone"]').text(translation.creator.configuration_building['option:label.yard_zone']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-enter_point"]').text(translation.creator.configuration_building['option:label.enter_point']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-exit_point"]').text(translation.creator.configuration_building['option:label.exit_point']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-__underground_parking"]').text(translation.creator.configuration_building['option:label.underground_parking']);
    $('.housing_creator .main > div[data-type="configuration-building"] .options label.input-name[for="building-enter_garage_point"]').text(translation.creator.configuration_building['option:label.enter_garage_point']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .text > div > .header').text(translation.creator.configuration_motel['header:subtitle']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .text > div > .title').text(translation.creator.configuration_motel['header:title']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .text > .buttons > .button.save').text(translation.creator.configuration_motel['header:buttons:save']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .text > .buttons > .button.delete').text(translation.creator.configuration_motel['header:buttons:delete']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .options label.input-name[for="motel-address"]').text(translation.creator.configuration_motel['option:label.address']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .options label.input-name[for="motel-region"]').text(translation.creator.configuration_motel['option:label.region']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .options label.input-name[for="motel-name"]').text(translation.creator.configuration_motel['option:label.motel_name']);
    $('.housing_creator .main > div[data-type="configuration-motel"] .options label.input-name[for="motel-yard_zone"]').text(translation.creator.configuration_motel['option:label.yard_zone']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .text > div > .header').text(translation.creator.configuration_furniture['header:subtitle']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .text > div > .title').text(translation.creator.configuration_furniture['header:title']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .text > .buttons > .button.save').text(translation.creator.configuration_furniture['header:buttons:save']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .text > .buttons > .button.delete').text(translation.creator.configuration_furniture['header:buttons:delete']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-label"]').text(translation.creator.configuration_furniture['option:label.label']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-price"]').text(translation.creator.configuration_furniture['option:label.price']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-tag"]').text(translation.creator.configuration_furniture['option:label.tag']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-environment"]').text(translation.creator.configuration_furniture['option:label.environment']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-inside"]').text(translation.creator.configuration_furniture['option:label.environment_inside']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-outside"]').text(translation.creator.configuration_furniture['option:label.environment_outside']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-delivery_size"]').text(translation.creator.configuration_furniture['option:label.delivery_size']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-delivery_small"]').text(translation.creator.configuration_furniture['option:label.delivery_size_small']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-delivery_medium"]').text(translation.creator.configuration_furniture['option:label.delivery_size_medium']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-delivery_big"]').text(translation.creator.configuration_furniture['option:label.delivery_size_big']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-interactable-name"]').text(translation.creator.configuration_furniture['option:label.interactable_name']);
    $('.housing_creator .main > div[data-type="configuration-furniture"] .options label.input-name[for="furniture-metadata"]').text(translation.creator.configuration_furniture['option:label.metadata']);
    $('.housing_creator .main > div[data-type="all-properties"] .text > div > .header').text(translation.creator.all_properties['header:subtitle']);
    $('.housing_creator .main > div[data-type="all-properties"] .text > div > .title').text(translation.creator.all_properties['header:title']);
    $('.housing_creator .main > div[data-type="all-properties"] .text > div.right-buttons > input.search').attr('placeholder', translation.creator.all_properties['header:search:placeholder']);
    $('.housing_creator div[data-type="all-properties"]>div>.side-boxes>.box>#properties-list>table>thead>tr>th#house_type').text(translation.creator.all_properties['table:head_label.type']);
    $('.housing_creator div[data-type="all-properties"]>div>.side-boxes>.box>#properties-list>table>thead>tr>th#house_name').text(translation.creator.all_properties['table:head_label.name']);
    $('.housing_creator div[data-type="all-properties"]>div>.side-boxes>.box>#properties-list>table>thead>tr>th#house_address').text(translation.creator.all_properties['table:head_label.address']);
    $('.housing_creator div[data-type="all-properties"]>div>.side-boxes>.box>#properties-list>table>thead>tr>th#house_owner').text(translation.creator.all_properties['table:head_label.owner']);
    $('.housing_creator div[data-type="all-properties"]>div>.side-boxes>.box>#properties-list>table>thead>tr>th#house_renter').text(translation.creator.all_properties['table:head_label.renter']);
    $('.housing_creator div[data-type="all-properties"]>div>.side-boxes>.box>#properties-list>table>thead>tr>th#actions').text(translation.creator.all_properties['table:head_label.actions']);
    $('.housing_creator .main > div[data-type="all-furniture"] .text > div > .header').text(translation.creator.all_furniture['header:subtitle']);
    $('.housing_creator .main > div[data-type="all-furniture"] .text > div > .title:not(.button-create)').text(translation.creator.all_furniture['header:title']);
    $('.housing_creator .main > div[data-type="all-furniture"] .text > div.right-buttons > input.search').attr('placeholder', translation.creator.all_furniture['header:search:placeholder']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#furniture_img').text(translation.creator.all_furniture['table:head_label.image']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#furniture_label').text(translation.creator.all_furniture['table:head_label.label']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#furniture_price').text(translation.creator.all_furniture['table:head_label.price']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#furniture_model').text(translation.creator.all_furniture['table:head_label.model']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#furniture_category').text(translation.creator.all_furniture['table:head_label.category']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#furniture_interactable').text(translation.creator.all_furniture['table:head_label.interactable']);
    $('.housing_creator div[data-type="all-furniture"]>div>.side-boxes>.box>#furniture-list>table>thead>tr>th#actions').text(translation.creator.all_furniture['table:head_label.actions']);
    
    // Property Management:
    $('.housing_manage .menu > #order-furniture-menu > div > .header').text(translation.manage.order['checkout:modal']['title'])
    $('.housing_manage .menu > .main > div[data-type="my-house"] .box > .options > .renter > .informations > .label').text(translation.manage.main['card_renter:label'])
    $('.housing_manage .menu > .main > div[data-type="my-house"] .box > .options > .renter > .informations > .button[data-action="rental-details"]').text(translation.manage.main['card_renter:button'])
    $('.housing_manage .menu > .main > div[data-type="orders-list"] .box > .furniture-list > table > thead > tr > th#status').text(translation.manage.orders['table:head_label.status'])
    $('.housing_manage .menu > .main > div[data-type="orders-list"] .box > .furniture-list > table > thead > tr > th#furniture').text(translation.manage.orders['table:head_label.furniture'])
    $('.housing_manage .menu > .main > div[data-type="order-furniture"] .box > .furniture-info > .your-orders > .informations > .label').text(translation.manage.order['card_check_orders:label'])
    $('.housing_manage .menu > .main > div[data-type="order-furniture"] .box > .furniture-info > .your-orders > .informations > .value').text(translation.manage.order['card_check_orders:description'])
    $('.housing_manage .main > div[data-type="order-furniture"] .furniture-filters > #search > input').attr('placeholder', translation.manage.order['search:placeholder']);
    $('.housing_manage .menu > .main > div[data-type="bills"] .box > .bills-list > table > thead > tr > th#bills_status').text(translation.manage.bills['table:head_label.status'])
    $('.housing_manage .menu > .main > div[data-type="bills"] .box > .bills-list > table > thead > tr > th#bills_period').text(translation.manage.bills['table:head_label.period'])
    $('.housing_manage .menu > .main > div[data-type="bills"] .box > .bills-list > table > thead > tr > th#bills_type').text(translation.manage.bills['table:head_label.type'])
    $('.housing_manage .menu > .main > div[data-type="bills"] .box > .bills-list > table > thead > tr > th#actions').text(translation.manage.bills['table:head_label.actions'])
    $('.housing_manage .menu > .main > div[data-type="keys"] .box > .keys-list > table > thead > tr > th#keys_identifier').text(translation.manage.keys['table:head_label.identifier'])
    $('.housing_manage .menu > .main > div[data-type="keys"] .box > .keys-list > table > thead > tr > th#actions').text(translation.manage.keys['table:head_label.actions'])
    $('.housing_manage .menu > .main > div[data-type="furniture"] .box > .furniture-list > table > thead > tr > th#furniture_environment').text(translation.manage.furniture['table:head_label.environment'])
    $('.housing_manage .menu > .main > div[data-type="furniture"] .box > .furniture-list > table > thead > tr > th#furniture_name').text(translation.manage.furniture['table:head_label.name'])
    $('.housing_manage .menu > .main > div[data-type="furniture"] .box > .furniture-list > table > thead > tr > th#actions').text(translation.manage.furniture['table:head_label.actions'])
    
    // Safe:
    $('.safe .safe-actions > #changePinBtn').text(translation.safe['buttons:change_pin'])
    
    // Furniture:
    $('.property_furniture .menu > #categories > span.title > span').text(translation.furniture.selection['option:label.categories']);
    $('.property_furniture .menu > #items > span.title > span').text(translation.furniture.selection['option:label.items']);

    // Furniture Purchase Menu:
    $('.property_furniture_purchase > .purchase > .buttons > #purchase[data-payment="cash"] > span').text(translation.furniture['purchase:modal']['btn.pay_cash']);
    $('.property_furniture_purchase > .purchase > .buttons > #purchase[data-payment="bank"] > span').text(translation.furniture['purchase:modal']['btn.pay_bank']);
    $('.property_furniture_purchase > .purchase > .buttons > #cancel').text(translation['button.cancel']);
    
    // Contract:
    $('.contract .card > .buttons > div[data-type="rent"]').text(translation.contract['buttons:rent']);
    $('.contract .card > .buttons > div[data-type="purchase"]').text(translation.contract['buttons:purchase']);

    // Offer:
    $('.property_offer .menu > .main > .informations > .house-region > div > span').text(translation.offer['card_region:label']);
    $('.property_offer .menu > .main > .informations > .house-area > div > span').text(translation.offer['card_area:label']);
    $('.property_offer .menu > .main > .informations > .house-rooms > div > span').text(translation.offer['card_rooms:label']);
    $('.property_offer .menu > .main > .informations > .house-garage > div > span').text(translation.offer['card_garage:label']);
    $('.property_offer .menu > .main > .informations > .house-parking-spaces > div > span').text(translation.offer['card_parking_spaces:label']);
    $('.property_offer .menu > .main > .informations > .house-purchase-price > div > span').text(translation.offer['card_purchase_price:label']);
    $('.property_offer .menu > .main > .informations > .house-rent-price > div > span').text(translation.offer['card_rent_price:label']);
    $('.property_offer .menu > .main > .informations > .house-electricity-bill > div > span').text(translation.offer['card_electricity_bill:label']);
    $('.property_offer .menu > .main > .informations > .house-internet-bill > div > span').text(translation.offer['card_internet_bill:label']);
    $('.property_offer .menu > .main > .informations > .house-water-bill > div > span').text(translation.offer['card_water_bill:label']);
    $('.property_offer .menu > .main > .buttons > .change_theme').text(translation.offer['buttons:change_theme']);
    $('.property_offer .menu > .main > .buttons > .view').text(translation.offer['buttons:view']);
    $('.property_offer .menu > .main > .buttons > .finalize').text(translation.offer['buttons:finalize']);
}

const formatDate = (timestamp) => {
    const date = new Date((Number(timestamp) * 1000));
    let hour = date.getHours();
    let minute = date.getMinutes();
    let day = date.getDate();
    let month = date.getMonth() + 1;
    let year = date.getFullYear();
    if (hour < 10) hour = '0' + hour
    if (minute < 10) minute = '0' + minute
    if (day < 10) day = '0' + day
    if (month < 10) month = '0' + month

    return { date: day + '.' + month + '.' + year, time: hour + ':' + minute }
};

const formatDeliveryTime = (ms) => {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(ms / (1000 * 60));
    const hours = Math.floor(ms / (1000 * 60 * 60));
    const days = Math.floor(ms / (1000 * 60 * 60 * 24));

    if (seconds < 60) {
        return `${seconds} ${translation['time.seconds']}`;
    } else if (minutes < 60) {
        return `${minutes} ${translation['time.minutes']}`;
    } else if (hours < 24) {
        return `${hours} ${translation['time.hours']}`;
    } else {
        return `${days} ${translation['time.days']}`;
    }
}

const getDeliveryStatus = (deliveryTimestamp) => {
    if (deliveryTimestamp) {
        const now = Math.floor(Date.now() / 1000);
        const secondsLeft = deliveryTimestamp - now;
        const minutesLeft = Math.ceil(secondsLeft / 60);

        if (minutesLeft > 60) return `<div class="furniture-delivery-tag status-1">${translation.delivery_statuses.status_1}</div>`;
        if (minutesLeft > 45) return `<div class="furniture-delivery-tag status-2">${translation.delivery_statuses.status_2}</div>`;
        if (minutesLeft > 35) return `<div class="furniture-delivery-tag status-3">${translation.delivery_statuses.status_3}</div>`;
        if (minutesLeft > 0) return `<div class="furniture-delivery-tag status-4">${(translation.delivery_statuses.status_4).format(minutesLeft)}</div>`;
    }
    
    return `<div class="furniture-delivery-tag status-5">${translation.delivery_statuses.status_5}</div>`;
}

const getRawValue = function (input) {
    return $(input).data('raw') || "0";
};