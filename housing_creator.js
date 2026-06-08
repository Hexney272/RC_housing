const propsInput = document.querySelector('.housing_creator>div>.menu>#register-new-furniture input[name="props-list"]');
const propsList = new Tagify(propsInput);

propsList.on('add', function(e) {
    let isCheckerEnabled = $('.inp-cbx[data-toggle="check-existing-furniture"]').prop('checked');
    const tagValue = e.detail.data.value;
    if (isCheckerEnabled && Property.FurnitureList[tagValue]) {
        propsList.removeTag(e.detail.tag);
    }
});

const HousingCreator = {
    IsModifyingExisting: false,
    ModifyingIdentifier: false,

    Pagination: {
        CurrentPage: 1,
        ItemsPerPage: 8,
        Array: [],
        ArrayFiltered: [],

        // currentFilter: "all",
        SearchTerm: "",
    },
    
    BuildingParkingId: null,
    BuildingParking: null,
    ApartmentParkingSpots: {},

    AllProperties: [],
    AvailableShells: [],
    AvailableIPLS: [],
    
    Open: function (data) {
        currentMenu = 'housing_creator';
        this.LoadMenu();
    },

    Close: function () {
        $(`.housing_creator, .housing_creator>div>.menu>#register-new-furniture`).fadeOut(120)
        currentMenu = null;
    },

    Update: function (data) {
        this.LoadMenusData(data.data);
    },

    LoadMenusData: function (vals) {
        if (vals) {
            if (vals.type == 'load-shells') {
                $('.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>#shells-list, .housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>.text .tags').empty();

                this.AvailableShells = vals.AvailableShells

                for (const [name, label] of Object.entries(config.shellsTags)) {
                    $('.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>.text .tags').append(`<div data-tag="${name}">${label}</div>`);
                }
            
                for (const [name, data] of Object.entries(this.AvailableShells)) {
                    let tagClasses = '';
                    let tagElements = '';
                    if (data.tags && data.tags.length >= 1) {
                        data.tags.forEach(tag => {
                            tagClasses = tagClasses + `tag-${tag} `;
                            if (config.shellsTags[tag]) tagElements = tagElements + `<div>${config.shellsTags[tag]}</div>`;
                        });
                    }
                    
                    let imagesCount = 0;
                    let imagesElements = '';
                    let imagesElementsDots = '';
                    if (data.images && data.images.length >= 1) {
                        data.images.forEach(url => {
                            imagesCount += 1;
                            imagesElements = imagesElements + `<img src="./images/${url}" draggable="false">`;
                            imagesElementsDots = imagesElementsDots + `<div class="thumbnail ${imagesCount == 1 ? 'active' : ''}"></div>`;
                        });
                    }

                    let newShellHTML = `
                        <div class="${tagClasses}">
                            <div class="tags">${tagElements}</div>
                            <p>${data.label}</p>
                            <div class="gallery-container">
                                ${imagesCount >= 1 ? `<button class="prev"><i class="fa-solid fa-angle-left"></i></button>` : ''}

                                <div class="gallery-wrapper">
                                    <div class="gallery">
                                        ${imagesCount >= 1 ? imagesElements : ''}
                                    </div>
                                    ${imagesCount >= 1 ? `<div class="thumbnails">${imagesElementsDots}</div>` : ''}
                                </div>

                                ${imagesCount >= 1 ? `<button class="next"><i class="fa-solid fa-angle-right"></i></button>` : ''}
                            </div>
                            <div class="buttons">
                                <div id="select-shell" data-shell="${name}">
                                    <i class="fa-solid fa-check"></i>
                                    <span>${translation['button.select']}</span>
                                </div>
                                <div id="preview-shell" data-shell="${name}">
                                    <i class="fa-solid fa-eye"></i>
                                    <span>${translation['button.preview']}</span>
                                </div>
                            </div>
                        </div>
                    `;

                    const newElement = $(newShellHTML);
                    $('.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>#shells-list').append(newElement);
                    
                    newElement.find('.gallery-container').each(function () {
                        initGallery($(this));
                    });
                }

            } else if (vals.type == 'load-ipls') {
                $('.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>#ipls-list').empty();

                this.AvailableIPLS = vals.AvailableIPLS

                for (const [name, label] of Object.entries(config.iplsTags)) {
                    $('.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>.text .tags').append(`<div data-tag="${name}">${label}</div>`);
                }
            
                for (const [name, data] of Object.entries(this.AvailableIPLS)) {
                    let tagClasses = '';
                    let tagElements = '';
                    if (data.tags && data.tags.length >= 1) {
                        data.tags.forEach(tag => {
                            tagClasses = tagClasses + `tag-${tag} `;
                            if (config.iplsTags[tag]) tagElements = tagElements + `<div>${config.iplsTags[tag]}</div>`;
                        });
                    }
                    
                    let imagesCount = 0;
                    let imagesElements = '';
                    let imagesElementsDots = '';
                    if (data.images && data.images.length >= 1) {
                        data.images.forEach(url => {
                            imagesCount += 1;
                            imagesElements = imagesElements + `<img src="./images/${url}" draggable="false">`;
                            imagesElementsDots = imagesElementsDots + `<div class="thumbnail ${imagesCount == 1 ? 'active' : ''}"></div>`;
                        });
                    }

                    let newIplHTML = `
                        <div class="${tagClasses}">
                            <div class="tags">${tagElements}</div>
                            <p>${data.label}</p>
                            <div class="gallery-container">
                                ${imagesCount >= 1 ? `<button class="prev"><i class="fa-solid fa-angle-left"></i></button>` : ''}
                                <div class="gallery-wrapper">
                                    <div class="gallery">
                                        ${imagesCount >= 1 ? imagesElements : ''}
                                    </div>
                                    ${imagesCount >= 1 ? `<div class="thumbnails">${imagesElementsDots}</div>` : ''}
                                </div>
                                ${imagesCount >= 1 ? `<button class="next"><i class="fa-solid fa-angle-right"></i></button>` : ''}
                            </div>
                            <div class="buttons">
                                <div id="select-ipl" data-ipl="${name}">
                                    <i class="fa-solid fa-check"></i>
                                    <span>${translation['button.select']}</span>
                                </div>
                                <div id="preview-ipl" data-ipl="${name}">
                                    <i class="fa-solid fa-eye"></i>
                                    <span>${translation['button.preview']}</span>
                                </div>
                            </div>
                        </div>
                    `;

                    const newElement = $(newIplHTML);
                    $('.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>#ipls-list').append(newElement);
                    
                    newElement.find('.gallery-container').each(function () {
                        initGallery($(this));
                    });
                }


            } else if (vals.type == 'new-shell') {
                $('.housing_creator div[data-type="new-shell"] > div > .side-boxes > .box > .text .tags > div').removeClass('active');
                $('.housing_creator div[data-type="new-shell"] > div > .side-boxes > .box > .text .tags > div[data-tag="default"]').addClass('active');
                $('.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>#shells-list > div').show();

            } else if (vals.type == 'new-ipl') {
                $('.housing_creator div[data-type="new-ipl"] > div > .side-boxes > .box > .text .tags > div').removeClass('active');
                $('.housing_creator div[data-type="new-ipl"] > div > .side-boxes > .box > .text .tags > div[data-tag="default"]').addClass('active');
                $('.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>#ipl-list > div').show();

            } else if (vals.type == 'configuration-mlo') {
                HousingCreator.ConfigurationMLO();

            } else if (vals.type == 'configuration-building') {
                HousingCreator.ConfigurationBuilding();

            } else if (vals.type == 'configuration-motel') {
                HousingCreator.ConfigurationMotel();

            } else if (vals.type == 'update-input-value') {
                $(`.housing_creator div[data-type="configuration-${vals.housingType}"]>div>.side-boxes>.box > .options .mt-2 > input[name="${vals.housingType}-${vals.inputName}"]`).val(vals.value).trigger('change')
                
            } else if (vals.type == 'update-doors-list') {
                let doorsHTML = '';
                if (vals.value && Object.keys(vals.value).length) {
                    for (const [doorId, doorData] of Object.entries(vals.value)) {
                        let doorIdentifier = Number(doorId) + 1
                        doorsHTML += `
                            <div class="mt-2">
                                <i>#${doorIdentifier}</i>
                                <input type="text" name="mlo-door-${doorIdentifier}" disabled="" value="${
                                    doorData.type == 'double' && translation.creator.configuration_mlo['option:door.double_door'] ||
                                    doorData.type == 'slide_gate' && translation.creator.configuration_mlo['option:door.slide_gate'] ||
                                    translation.creator.configuration_mlo['option:door.single_door']
                                } (${doorData.type == 'slide_gate' && (doorData.distance || 8.5) || (doorData.distance || 1.5)}m)" style="width: 16.35em;">
                                <div class="button" onclick="HousingCreator.TeleportToDoor('${doorIdentifier}')">
                                    <i class="fa-solid fa-street-view"></i>
                                </div>
                                <div class="button" data-button-action="mlo-remove_door" data-door-id="${doorIdentifier}">
                                    <i class="fa-solid fa-trash-can"></i>
                                </div>
                            </div>
                        `
                    }
                }
                $('.housing_creator div[data-type="configuration-mlo"]>div>.side-boxes>.box>.options .mlo-doors>.doors-list').html(doorsHTML);
            } else if (vals.type == 'show-menu') {
                $('.housing_creator').fadeIn(120);

            } else if (vals.type == 'hide-menu') {
                $(`.housing_creator`).fadeOut(120)

            }
        }
    },

    LoadMenu: function () {
        // let firstMenu = null;
        updateSection('.housing_creator', 'new', `.housing_creator li[data-href="new"]`);
        $('.housing_creator').fadeIn(120);
    },


    ResetShell: function () {
        this.IsModifyingExisting = false;
        this.ModifyingIdentifier = null;
        
        $(`
            .inp-cbx[data-toggle="shell-building"],
            .inp-cbx[data-toggle="shell-motel"],

            .inp-cbx[data-toggle="shell-purchase_price"],
            .inp-cbx[data-toggle="shell-rent_price"],

            .inp-cbx[data-toggle="shell-__garage"],
            .inp-cbx[data-toggle="shell-__parking"],
            
            .inp-cbx[data-toggle="shell-delivery_inside"],
            .inp-cbx[data-toggle="shell-delivery_outside"],
            
            .inp-cbx[data-toggle="shell-furniture_environment_inside"],
            .inp-cbx[data-toggle="shell-furniture_environment_outside"],
            
            .inp-cbx[data-toggle="shell-wardrobe"],
            .inp-cbx[data-toggle="shell-storage"],
            
            .inp-cbx[data-toggle="shell-keys_limit"],
            .inp-cbx[data-toggle="shell-permissions_limit"]
        `).prop('checked', false);

        $(`
            input[name="shell-purchase_price"],
            input[name="shell-rent_price"],

            .housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2 > select,
            .housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2 > select,

            .housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-slots-value"],
            .housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-weight-value"],

            .housing_creator div[data-type="configuration-shell"] input[name="shell-keys_limit_count"],
            .housing_creator div[data-type="configuration-shell"] input[name="shell-permissions_limit_count"]
        `).prop('disabled', true);

        $(`
            .housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2 > select,
            .housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2 > select
        `).prop('selectedIndex', 0).trigger('change');

        $(`
            input[name="shell-address"],
            input[name="shell-region"],
            input[name="shell-house_name"],
            textarea[name="shell-house_description"],
            input[name="shell-purchase_price"],
            input[name="shell-rent_price"],
            input[name="shell-name"],
            input[name="shell-yard_zone"],
            input[name="shell-enter_point"],
            input[name="shell-exit_point"],
            input[name="shell-garage_point"],
            input[name="shell-delivery_coordinates"],
            input[name="shell-wardrobe_point"],
            input[name="shell-storage_point"],
            input[name="shell-keys_limit_count"],
            input[name="shell-permissions_limit_count"]
        `).val('');
        
        $(`.housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-slots-value"]`).val('');
        $(`.housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-weight-value"]`).val('');
        
        $(`.housing_creator div[data-type="configuration-shell"] .shell-parking_space`).hide();
    },

    ResetIPL: function () {
        this.IsModifyingExisting = false;
        this.ModifyingIdentifier = null;

        $(`
            .inp-cbx[data-toggle="ipl-building"],
            .inp-cbx[data-toggle="ipl-motel"],

            .inp-cbx[data-toggle="ipl-purchase_price"],
            .inp-cbx[data-toggle="ipl-rent_price"],

            .inp-cbx[data-toggle="ipl-__theme_purchase_change"],
            .inp-cbx[data-toggle="ipl-__theme_purchased_change"],

            .inp-cbx[data-toggle="ipl-__garage"],
            .inp-cbx[data-toggle="ipl-__parking"],
            
            .inp-cbx[data-toggle="ipl-delivery_inside"],
            .inp-cbx[data-toggle="ipl-delivery_outside"],
            
            .inp-cbx[data-toggle="ipl-furniture_environment_inside"],
            .inp-cbx[data-toggle="ipl-furniture_environment_outside"],
            
            .inp-cbx[data-toggle="ipl-wardrobe"],
            .inp-cbx[data-toggle="ipl-storage"],
            
            .inp-cbx[data-toggle="ipl-keys_limit"],
            .inp-cbx[data-toggle="ipl-permissions_limit"]
        `).prop('checked', false);

        $(`
            input[name="ipl-purchase_price"],
            input[name="ipl-rent_price"],

            .housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2 > select,
            .housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2 > select,

            .housing_creator div[data-type="configuration-ipl"] .ipl-theme > .mt-2 > select,

            .housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-slots-value"],
            .housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-weight-value"],

            .housing_creator div[data-type="configuration-ipl"] input[name="ipl-keys_limit_count"],
            .housing_creator div[data-type="configuration-ipl"] input[name="ipl-permissions_limit_count"]
        `).prop('disabled', true);

        $(`
            .housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2 > select,
            .housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2 > select,
            .housing_creator div[data-type="configuration-ipl"] .ipl-theme > .mt-2 > select
        `).prop('selectedIndex', 0).trigger('change');

        $(`
            input[name="ipl-address"],
            input[name="ipl-region"],
            input[name="ipl-house_name"],
            textarea[name="ipl-house_description"],
            input[name="ipl-purchase_price"],
            input[name="ipl-rent_price"],
            input[name="ipl-name"],
            input[name="ipl-yard_zone"],
            input[name="ipl-enter_point"],
            input[name="ipl-exit_point"],
            input[name="ipl-garage_point"],
            input[name="ipl-delivery_coordinates"],
            input[name="ipl-wardrobe_point"],
            input[name="ipl-storage_point"],
            input[name="ipl-keys_limit_count"],
            input[name="ipl-permissions_limit_count"]
        `).val('');
        
        $(`.housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-slots-value"]`).val('');
        $(`.housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-weight-value"]`).val('');
        
        $(`.housing_creator div[data-type="configuration-ipl"] .ipl-parking_space`).hide();
    },

    ResetMLO: function () {
        this.IsModifyingExisting = false;
        this.ModifyingIdentifier = null;

        $(`
            .inp-cbx[data-toggle="mlo-motel"],

            .inp-cbx[data-toggle="mlo-purchase_price"],
            .inp-cbx[data-toggle="mlo-rent_price"],

            .inp-cbx[data-toggle="mlo-__garage"],
            .inp-cbx[data-toggle="mlo-__parking"],
            
            .inp-cbx[data-toggle="mlo-delivery_inside"],
            .inp-cbx[data-toggle="mlo-delivery_outside"],
            
            .inp-cbx[data-toggle="mlo-furniture_environment_inside"],
            .inp-cbx[data-toggle="mlo-furniture_environment_outside"],
            
            .inp-cbx[data-toggle="mlo-wardrobe"],
            .inp-cbx[data-toggle="mlo-storage"],
            
            .inp-cbx[data-toggle="mlo-keys_limit"],
            .inp-cbx[data-toggle="mlo-permissions_limit"]
        `).prop('checked', false);

        $(`
            input[name="mlo-purchase_price"],
            input[name="mlo-rent_price"],

            .housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2 > select,

            .housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-slots-value"],
            .housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-weight-value"],

            .housing_creator div[data-type="configuration-mlo"] input[name="mlo-keys_limit_count"],
            .housing_creator div[data-type="configuration-mlo"] input[name="mlo-permissions_limit_count"]
        `).prop('disabled', true);

        $(`
            .housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2 > select
        `).prop('selectedIndex', 0).trigger('change');

        $(`
            input[name="mlo-address"],
            input[name="mlo-region"],
            input[name="mlo-house_name"],
            textarea[name="mlo-house_description"],
            input[name="mlo-purchase_price"],
            input[name="mlo-rent_price"],
            input[name="mlo-yard_zone"],
            input[name="mlo-interior_zone"],
            input[name="mlo-menu_point"],
            input[name="mlo-garage_point"],
            input[name="mlo-delivery_coordinates"],
            input[name="mlo-wardrobe_point"],
            input[name="mlo-storage_point"],
            input[name="mlo-keys_limit_count"],
            input[name="mlo-permissions_limit_count"]
        `).val('');
        
        $(`.housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-slots-value"]`).val('');
        $(`.housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-weight-value"]`).val('');
        
        $(`.housing_creator div[data-type="configuration-mlo"] .mlo-doors > .doors-list`).empty();

        $(`.housing_creator div[data-type="configuration-mlo"] .mlo-parking_space`).hide();
    },

    ResetBuilding: function () {
        this.IsModifyingExisting = false;
        this.ModifyingIdentifier = null;
        
        $(`
            .inp-cbx[data-toggle="building-__underground_parking"]
        `).prop('checked', false);

        $(`
            input[name="building-underground_parking_floors"]
        `).prop('disabled', true);

        $(`
            input[name="building-address"],
            input[name="building-region"],
            input[name="building-name"],
            input[name="building-yard_zone"],
            input[name="building-enter_point"],
            input[name="building-exit_point"],
            input[name="building-enter_garage_point"],
            input[name="building-underground_parking_floors"]
        `).val('');
    },

    ResetMotel: function () {
        this.IsModifyingExisting = false;
        this.ModifyingIdentifier = null;

        $(`
            input[name="motel-address"],
            input[name="motel-region"],
            input[name="motel-name"],
            input[name="motel-yard_zone"]
        `).val('');
    },


    ConfigurationShell: function (shellName) {
        this.ResetShell();

        $('.housing_creator div[data-type="configuration-shell"] .text > div > .delete').hide();
        $(`.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box > .options .mt-2 > input[name="shell-name"]`).val(shellName)

        $.post(`https://${GetParentResourceName()}/creator:getAllBuildings`, JSON.stringify({}), (response) => {
            $('.housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2').html(`<select></select>`);
            $('.housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2').html(`<select></select>`);

            let buildings = [{
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            }];

            for (const [name, data] of Object.entries(response.buildings)) {
                buildings.push({
                    id: data.id,
                    text: data.label,
                    isMenuBuilding: data.isMenuBuilding
                });
            }
            
            $('.housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2 > select').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: buildings
            }).prop('disabled', true);

            let motels = [{
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            }];

            for (const [name, data] of Object.entries(response.motels)) {
                motels.push({
                    id: data.id,
                    text: data.label,
                });
            }
            
            $('.housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2 > select').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: motels
            }).prop('disabled', true);
        });
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'shell',
            action: 'address'
        }));
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'shell',
            action: 'region'
        }));
    },

    ConfigurationIPL: function (iplName) {
        this.ResetIPL();

        $('.housing_creator div[data-type="configuration-ipl"] .text > div > .delete').hide();
        $(`.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box > .options .mt-2 > input[name="ipl-name"]`).val(iplName)

        $.post(`https://${GetParentResourceName()}/creator:getAllBuildings`, JSON.stringify({}), (response) => {
            $('.housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2').html(`<select></select>`);
            $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2').html(`<select></select>`);

            let buildings = [{
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            }];

            for (const [name, data] of Object.entries(response.buildings)) {
                buildings.push({
                    id: data.id,
                    text: data.label,
                    isMenuBuilding: data.isMenuBuilding
                });
            }
            
            $('.housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2 > select').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: buildings
            }).prop('disabled', true);

            let motels = [{
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            }];

            for (const [name, data] of Object.entries(response.motels)) {
                motels.push({
                    id: data.id,
                    text: data.label,
                });
            }
            
            $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2 > select').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: motels
            }).prop('disabled', true);
        });

        $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme > .mt-2').html(`<select></select>`);
        let iplThemes = [
            {
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            }
        ];
        for (const [name, data] of Object.entries(this.AvailableIPLS[iplName].settings.Themes)) {
            iplThemes.push({
                id: name,
                text: data.label
            });
        }
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme > .mt-2 > select').select2({
            minimumResultsForSearch: Infinity,
            allowClear: false,
            data: iplThemes
        });

        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'ipl',
            action: 'address'
        }));
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'ipl',
            action: 'region'
        }));
    },
    
    ConfigurationMLO: function () {
        this.ResetMLO();

        $('.housing_creator div[data-type="configuration-mlo"] .text > div > .delete').hide();

        $.post(`https://${GetParentResourceName()}/creator:getAllBuildings`, JSON.stringify({}), (response) => {
            $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2').html(`<select></select>`);

            let motels = [{
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            }];

            for (const [name, data] of Object.entries(response.motels)) {
                motels.push({
                    id: data.id,
                    text: data.label,
                });
            }
            
            $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2 > select').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: motels
            }).prop('disabled', true);
        });
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'mlo',
            action: 'address'
        }));
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'mlo',
            action: 'region'
        }));
    },

    ConfigurationBuilding: function () {
        this.ResetBuilding();

        $('.housing_creator div[data-type="configuration-building"] .text > div > .delete').hide();

        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'building',
            action: 'address'
        }));
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'building',
            action: 'region'
        }));
    },

    ConfigurationMotel: function () {
        this.ResetMotel();

        $('.housing_creator div[data-type="configuration-motel"] .text > div > .delete').hide();
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'motel',
            action: 'address'
        }));
        
        $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
            type: 'motel',
            action: 'region'
        }));
    },

    
    TeleportToProperty: function (id) {
        $.post(`https://${GetParentResourceName()}/creator:teleportToProperty`, JSON.stringify({id:id}));
    },

    TeleportToDoor: function (id) {
        $.post(`https://${GetParentResourceName()}/creator:teleportToDoors`, JSON.stringify({id: id}));
    },

    RemoveOwner: function (id) {
        $.post(`https://${GetParentResourceName()}/creator:removeOwner`, JSON.stringify({id: id}));
    },

    RemoveRenter: function (id) {
        $.post(`https://${GetParentResourceName()}/creator:removeRenter`, JSON.stringify({id: id}));
    },
    
    EditHouse: function (id) {
        let house = null;
        
        for (const item of this.Pagination.Array) {
            if (item.id == id) {
                house = item;
                break;
            }
        }

        if (!house) return;

        $.post(`https://${GetParentResourceName()}/creator:loadPropertyConfig`, JSON.stringify({id:id}));

        updateSection('.housing_creator', `configuration-${house.type}`);

        $(`.housing_creator div[data-type="configuration-${house.type}"] .text .button.save`).addClass('allowed');
        $(`.housing_creator div[data-type="configuration-${house.type}"] .text .button.delete`).show();

        if (house.type == 'shell') {
            // this.ResetShell();

            this.IsModifyingExisting = true;
            this.ModifyingIdentifier = house.id;
            
            // updateSection('.housing_creator', 'configuration-shell');
            
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-name"]').val(house.metadata.shell);
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-address"]').val(house.address);
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-region"]').val(house.region);
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-house_name"]').val(house.name);
            $('.housing_creator div[data-type="configuration-shell"] textarea[name="shell-house_description"]').val(house.description);
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-yard_zone"]').val(JSON.stringify(house.metadata.zone));
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-enter_point"]').val(JSON.stringify(house.metadata.enter));
            $('.housing_creator div[data-type="configuration-shell"] input[name="shell-exit_point"]').val(JSON.stringify(house.metadata.exit));

            $.post(`https://${GetParentResourceName()}/creator:getAllBuildings`, JSON.stringify({}), (response) => {
                $('.housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2').html(`<select></select>`);
                $('.housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2').html(`<select></select>`);

                let buildings = [{
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: house.object_id === undefined
                }];

                let isBuilding = false
                for (const [name, data] of Object.entries(response.buildings)) {
                    buildings.push({
                        id: data.id,
                        text: data.label,
                        isMenuBuilding: data.isMenuBuilding,
                        selected: house.object_id === data.id
                    });
                    if (house.object_id === data.id) isBuilding = true;
                }
    
                $('.housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2 > select').select2({
                    minimumResultsForSearch: Infinity,
                    allowClear: false,
                    data: buildings
                }).prop('disabled', !isBuilding);
                $('.inp-cbx[data-toggle="shell-building"]').prop('checked', isBuilding);

                if (isBuilding && usingVMSGarages) {
                    $.post(`https://${GetParentResourceName()}/creator:getBuildingParking`, JSON.stringify({ id: house.object_id }), function (parking) {
                        if (parking) {
                            HousingCreator.BuildingParkingId = house.object_id;
                            HousingCreator.BuildingParking = parking;
                            let parkingFloors = 0;
                            let parkingFloorsHTML = '';
                            for (const [floor, _] of Object.entries(HousingCreator.BuildingParking)) {
                                parkingFloors += 1;
                                parkingFloorsHTML += `<div data-floor="${floor}" ${floor === "1" ? 'class="active"': ''}>${(translation.creator.configuration_shell['option:label.parking_space_floor']).format(floor)}</div>`;
                            }
                            $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-floors').html(parkingFloorsHTML).css('grid-template-columns', `repeat(${parkingFloors}, 1fr)`);

                            let parkingSpacesHTML = '';
                            for (let i=1; i <= 38; i++) {
                                const inputId = `shell-parking_space_${i}`;

                                const parkingOwner = HousingCreator.BuildingParking["1"][String(i)];
                                const isBlocked = (HousingCreator.ModifyingIdentifier && parkingOwner && parkingOwner !== HousingCreator.ModifyingIdentifier);

                                parkingSpacesHTML += `
                                    <div class="checkbox-wrapper-46 ${isBlocked ? 'not-allowed' : ''}">
                                        <input
                                            type="checkbox"
                                            id="${inputId}"
                                            class="inp-cbx ${isBlocked ? 'not-allowed' : ''}"
                                            data-toggle="shell-parking_space"
                                            data-floor="${1}"
                                            data-parking-space="${i}"
                                            ${parkingOwner === HousingCreator.ModifyingIdentifier ? 'checked' : ''}
                                        >
                                        <label for="${inputId}" class="cbx">
                                            <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                                            <label for="${inputId}" class="input-name">#${i}</label>
                                        </label>
                                    </div>
                                `
                            }
                            
                            HousingCreator.ApartmentParkingSpots = {}
                            for (const [floor, floorData] of Object.entries(HousingCreator.BuildingParking)) {
                                for (const [spot, apartment] of Object.entries(floorData)) {
                                    if (String(apartment) === String(HousingCreator.ModifyingIdentifier)) {
                                        if (!HousingCreator.ApartmentParkingSpots[String(floor)]) {
                                            HousingCreator.ApartmentParkingSpots[String(floor)] = []
                                        }
                                        HousingCreator.ApartmentParkingSpots[String(floor)].push(String(spot))
                                    }
                                }
                            }

                            $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space').show();
                            $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-spaces').html(parkingSpacesHTML);
                        } else {
                            HousingCreator.BuildingParkingId = null;
                            HousingCreator.BuildingParking = null;
                            HousingCreator.ApartmentParkingSpots = null;
                            $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space').hide();
                            $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-spaces').empty();
                        }
                    });
                }

                let motels = [{
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: house.object_id === undefined
                }];
    
                let isMotel = false;
                for (const [name, data] of Object.entries(response.motels)) {
                    motels.push({
                        id: data.id,
                        text: data.label,
                        // isMenuBuilding: data.isMenuBuilding
                    });
                    if (house.object_id === data.id) isMotel = true;
                }
                
                $('.housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2 > select').select2({
                    minimumResultsForSearch: Infinity,
                    allowClear: false,
                    data: motels
                }).prop('disabled', !isMotel);
                $('.inp-cbx[data-toggle="shell-motel"]').prop('checked', isMotel);
            });

            $('.inp-cbx[data-toggle="shell-__garage"]').prop('checked', false);
            $('.inp-cbx[data-toggle="shell-__parking"]').prop('checked', false);
            $('input[name="shell-garage_point"]').val('');
            if (house.metadata.garage) {
                $('.inp-cbx[data-toggle="shell-__garage"]').prop('checked', true);
                $('input[name="shell-garage_point"]').val(JSON.stringify(house.metadata.garage));
            }
            if (house.metadata.parking) {
                $('.inp-cbx[data-toggle="shell-__parking"]').prop('checked', true);
                $('input[name="shell-garage_point"]').val(JSON.stringify(house.metadata.parking));
            }

            $('.inp-cbx[data-toggle="shell-emergency_exit"]').prop('checked', false);
            $('input[name="shell-emergency_exit_outside"], input[name="shell-emergency_exit_inside"]').val('');
            if (house.metadata.emergencyOutside) {
                $('.inp-cbx[data-toggle="shell-emergency_exit"]').prop('checked', true);
                $('input[name="shell-emergency_exit_outside"]').val(JSON.stringify(house.metadata.emergencyOutside));
            }
            if (house.metadata.emergencyInside) {
                $('.inp-cbx[data-toggle="shell-emergency_exit"]').prop('checked', true);
                $('input[name="shell-emergency_exit_inside"]').val(JSON.stringify(house.metadata.emergencyInside));
            }
            
            $('.inp-cbx[data-toggle="shell-delivery_inside"]').prop('checked', house.metadata.deliveryType == 'inside');
            $('.inp-cbx[data-toggle="shell-delivery_outside"]').prop('checked', house.metadata.deliveryType == 'outside');
            $('input[name="shell-delivery_coordinates"]').val('');
            if (house.metadata.delivery) $('input[name="shell-delivery_coordinates"]').val(JSON.stringify(house.metadata.delivery));
            
            $('.inp-cbx[data-toggle="shell-furniture_environment_outside"]').prop('checked', house.metadata.allowFurnitureOutside);
            $('.inp-cbx[data-toggle="shell-furniture_environment_inside"]').prop('checked', house.metadata.allowFurnitureInside);
            
            $('input[name="shell-wardrobe_point"]').val('');
            if (house.metadata.wardrobe) {
                $('.inp-cbx[data-toggle="shell-wardrobe"]').prop('checked', true);
                $('input[name="shell-wardrobe_point"]').val(JSON.stringify(house.metadata.wardrobe));
            }

            $('input[name="shell-storage_point"]').val('');
            if (house.metadata.storage) {
                $('.inp-cbx[data-toggle="shell-storage"]').prop('checked', true);
                $('input[name="shell-storage_point"]').val(JSON.stringify(house.metadata.storage));
                $('.shell-storage input[name="metadata-slots-value"]').val(house.metadata.storage.slots).prop('disabled', false);
                $('.shell-storage input[name="metadata-weight-value"]').val(house.metadata.storage.weight).prop('disabled', false);
            }
            
            $('input[name="shell-keys_limit_count"]').val('');
            if (house.metadata.keysLimit) {
                $('.inp-cbx[data-toggle="shell-keys_limit"]').prop('checked', true);
                $('input[name="shell-keys_limit_count"]').val(house.metadata.keysLimit).prop('disabled', false);
            }
            
            $('input[name="shell-permissions_limit_count"]').val('');
            if (house.metadata.permissionsLimit) {
                $('.inp-cbx[data-toggle="shell-permissions_limit"]').prop('checked', true);
                $('input[name="shell-permissions_limit_count"]').val(house.metadata.permissionsLimit).prop('disabled', false);
            }

            $('.inp-cbx[data-toggle="shell-purchase_price"]').prop('checked', house.sale.active);
            $('input[name="shell-purchase_price"]').val(house.sale.defaultPrice);
            if (house.sale.active) {
                $('input[name="shell-purchase_price"]').prop('disabled', false);
            }

            $('.inp-cbx[data-toggle="shell-rent_price"]').prop('checked', house.rental.active);
            $('input[name="shell-rent_price"]').val(house.rental.defaultPrice);
            if (house.rental.active) {
                $('input[name="shell-rent_price"]').prop('disabled', false);
            }

            setTimeout(() => {
                checkShellInputs()
            }, 80);

        } else if (house.type == 'ipl') {
            // this.ResetIPL();

            this.IsModifyingExisting = true;
            this.ModifyingIdentifier = house.id;

            // updateSection('.housing_creator', 'configuration-ipl');
            
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-name"]').val(house.metadata.ipl);
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-address"]').val(house.address);
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-region"]').val(house.region);
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-house_name"]').val(house.name);
            $('.housing_creator div[data-type="configuration-ipl"] textarea[name="ipl-house_description"]').val(house.description);
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-yard_zone"]').val(JSON.stringify(house.metadata.zone));
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-enter_point"]').val(JSON.stringify(house.metadata.enter));
            $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-exit_point"]').val(JSON.stringify(house.metadata.exit));

            this.BuildingParkingId = null;
            this.BuildingParking = null;
            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space').hide();
            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-spaces').empty();

            $.post(`https://${GetParentResourceName()}/creator:getAllBuildings`, JSON.stringify({}), (response) => {
                $('.housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2').html(`<select></select>`);
                $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2').html(`<select></select>`);

                let buildings = [{
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: house.object_id === undefined
                }];

                let isBuilding = false
                for (const [name, data] of Object.entries(response.buildings)) {
                    buildings.push({
                        id: data.id,
                        text: data.label,
                        isMenuBuilding: data.isMenuBuilding,
                        selected: house.object_id === data.id
                    });
                    if (house.object_id === data.id) isBuilding = true;
                }
    
                $('.housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2 > select').select2({
                    minimumResultsForSearch: Infinity,
                    allowClear: false,
                    data: buildings
                }).prop('disabled', !isBuilding);
                $('.inp-cbx[data-toggle="ipl-building"]').prop('checked', isBuilding);

                if (isBuilding && usingVMSGarages) {
                    $.post(`https://${GetParentResourceName()}/creator:getBuildingParking`, JSON.stringify({ id: house.object_id }), function (parking) {
                        if (parking) {
                            HousingCreator.BuildingParkingId = house.object_id;
                            HousingCreator.BuildingParking = parking;
                            let parkingFloorsHTML = '';
                            for (const [floor, _] of Object.entries(HousingCreator.BuildingParking)) {
                                parkingFloorsHTML += `<div data-floor="${floor}" ${floor === "1" ? 'class="active"': ''}>${(translation.creator.configuration_ipl['option:label.parking_space_floor']).format(floor)}</div>`;
                            }
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-floors').html(parkingFloorsHTML);
    
                            let parkingSpacesHTML = '';
                            for (let i=1; i <= 38; i++) {
                                const inputId = `ipl-parking_space_${i}`;
                                parkingSpacesHTML += `
                                    <div class="checkbox-wrapper-46">
                                        <input type="checkbox" id="${inputId}" class="inp-cbx" data-toggle="ipl-parking_space" data-floor="1" data-parking-space="${i}" ${HousingCreator.BuildingParking["1"][String(i)] === house.id ? 'checked' : ''}>
                                        <label for="${inputId}" class="cbx">
                                            <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                                            <label for="${inputId}" class="input-name">#${i}</label>
                                        </label>
                                    </div>
                                `
                            }

                            HousingCreator.ApartmentParkingSpots = {};
                            for (const [floor, floorData] of Object.entries(HousingCreator.BuildingParking)) {
                                for (const [spot, apartment] of Object.entries(floorData)) {
                                    if (String(apartment) === String(house.id)) {
                                        if (!HousingCreator.ApartmentParkingSpots[floor]) {
                                            HousingCreator.ApartmentParkingSpots[floor] = [];
                                        }
                                        HousingCreator.ApartmentParkingSpots[floor].push(spot);
                                    }
                                }
                            }
                            
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space').show();
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-spaces').html(parkingSpacesHTML);
                        }
                    });
                }

                let motels = [{
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: house.object_id === undefined
                }];
    
                let isMotel = false;
                for (const [name, data] of Object.entries(response.motels)) {
                    motels.push({
                        id: data.id,
                        text: data.label,
                        // isMenuBuilding: data.isMenuBuilding
                    });
                    if (house.object_id === data.id) isMotel = true;
                }
                
                $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2 > select').select2({
                    minimumResultsForSearch: Infinity,
                    allowClear: false,
                    data: motels
                }).prop('disabled', !isMotel);
                $('.inp-cbx[data-toggle="ipl-motel"]').prop('checked', isMotel);
            });

            $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme > .mt-2').html(`<select></select>`);
            let iplThemes = [
                {
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: true
                }
            ];
            if (this.AvailableIPLS[house.metadata.ipl] && this.AvailableIPLS[house.metadata.ipl].settings && this.AvailableIPLS[house.metadata.ipl].settings.Themes) {
                for (const [name, data] of Object.entries(this.AvailableIPLS[house.metadata.ipl].settings.Themes)) {
                    iplThemes.push({
                        id: name,
                        text: data.label,
                        selected: name == house.metadata.iplTheme,
                    });
                }
            }
            $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme > .mt-2 > select').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: iplThemes
            });

            $('.inp-cbx[data-toggle="ipl-__theme_purchase_change"]').prop('checked', house.metadata.allowChangeTheme);
            $('.inp-cbx[data-toggle="ipl-__theme_purchased_change"]').prop('checked', house.metadata.allowChangeThemePurchased);

            $('.inp-cbx[data-toggle="ipl-__garage"]').prop('checked', false);
            $('.inp-cbx[data-toggle="ipl-__parking"]').prop('checked', false);
            $('input[name="ipl-garage_point"]').val('');
            if (house.metadata.garage) {
                $('.inp-cbx[data-toggle="ipl-__garage"]').prop('checked', true);
                $('input[name="ipl-garage_point"]').val(JSON.stringify(house.metadata.garage));
            }
            if (house.metadata.parking) {
                $('.inp-cbx[data-toggle="ipl-__parking"]').prop('checked', true);
                $('input[name="ipl-garage_point"]').val(JSON.stringify(house.metadata.parking));
            }
            
            $('.inp-cbx[data-toggle="ipl-emergency_exit"]').prop('checked', false);
            $('input[name="ipl-emergency_exit_outside"], input[name="ipl-emergency_exit_inside"]').val('');
            if (house.metadata.emergencyOutside) {
                $('.inp-cbx[data-toggle="ipl-emergency_exit"]').prop('checked', true);
                $('input[name="ipl-emergency_exit_outside"]').val(JSON.stringify(house.metadata.emergencyOutside));
            }
            if (house.metadata.emergencyInside) {
                $('.inp-cbx[data-toggle="ipl-emergency_exit"]').prop('checked', true);
                $('input[name="ipl-emergency_exit_inside"]').val(JSON.stringify(house.metadata.emergencyInside));
            }

            $('.inp-cbx[data-toggle="ipl-delivery_inside"]').prop('checked', house.metadata.deliveryType == 'inside');
            $('.inp-cbx[data-toggle="ipl-delivery_outside"]').prop('checked', house.metadata.deliveryType == 'outside');
            $('input[name="ipl-delivery_coordinates"]').val('');
            if (house.metadata.delivery) $('input[name="ipl-delivery_coordinates"]').val(JSON.stringify(house.metadata.delivery));
            
            $('.inp-cbx[data-toggle="ipl-furniture_environment_outside"]').prop('checked', house.metadata.allowFurnitureOutside);
            $('.inp-cbx[data-toggle="ipl-furniture_environment_inside"]').prop('checked', house.metadata.allowFurnitureInside);
            
            $('input[name="ipl-wardrobe_point"]').val('');
            if (house.metadata.wardrobe) {
                $('.inp-cbx[data-toggle="ipl-wardrobe"]').prop('checked', true);
                $('input[name="ipl-wardrobe_point"]').val(JSON.stringify(house.metadata.wardrobe));
            }

            $('input[name="ipl-storage_point"]').val('');
            if (house.metadata.storage) {
                $('.inp-cbx[data-toggle="ipl-storage"]').prop('checked', true);
                $('input[name="ipl-storage_point"]').val(JSON.stringify(house.metadata.storage));
                $('.ipl-storage input[name="metadata-slots-value"]').val(house.metadata.storage.slots);
                $('.ipl-storage input[name="metadata-weight-value"]').val(house.metadata.storage.weight);
            }
            
            $('input[name="ipl-keys_limit_count"]').val('');
            if (house.metadata.keysLimit) {
                $('.inp-cbx[data-toggle="ipl-keys_limit"]').prop('checked', true);
                $('input[name="ipl-keys_limit_count"]').val(house.metadata.keysLimit).prop('disabled', false);
            }
            
            $('input[name="ipl-permissions_limit_count"]').val('');
            if (house.metadata.permissionsLimit) {
                $('.inp-cbx[data-toggle="ipl-permissions_limit"]').prop('checked', true);
                $('input[name="ipl-permissions_limit_count"]').val(house.metadata.permissionsLimit).prop('disabled', false);
            }

            $('.inp-cbx[data-toggle="ipl-purchase_price"]').prop('checked', house.sale.active);
            $('input[name="ipl-purchase_price"]').val(house.sale.defaultPrice).attr('disabled', false);

            $('.inp-cbx[data-toggle="ipl-rent_price"]').prop('checked', house.rental.active);
            $('input[name="ipl-rent_price"]').val(house.rental.defaultPrice).attr('disabled', false);

            setTimeout(() => {
                checkIplInputs()
            }, 80);

        } else if (house.type == 'mlo') {
            // this.ResetMLO();

            this.IsModifyingExisting = true;
            this.ModifyingIdentifier = house.id;

            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-name"]').val(house.metadata.shell);
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-address"]').val(house.address);
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-region"]').val(house.region);
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-house_name"]').val(house.name);
            $('.housing_creator div[data-type="configuration-mlo"] textarea[name="mlo-house_description"]').val(house.description);
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-yard_zone"]').val(JSON.stringify(house.metadata.zone));
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-interior_zone"]').val(JSON.stringify(house.metadata.interiorZone));
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-menu_point"]').val(JSON.stringify(house.metadata.menu));
            $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-delivery_coordinates"]').val(JSON.stringify(house.metadata.delivery));

            $.post(`https://${GetParentResourceName()}/creator:getAllBuildings`, JSON.stringify({}), (response) => {
                $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2').html(`<select></select>`);

                let motels = [{
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: house.object_id === undefined
                }];
    
                let isMotel = false;
                for (const [name, data] of Object.entries(response.motels)) {
                    motels.push({
                        id: data.id,
                        text: data.label,
                        // isMenuBuilding: data.isMenuBuilding
                    });
                    if (house.object_id === data.id) isMotel = true;
                }
                
                $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2 > select').select2({
                    minimumResultsForSearch: Infinity,
                    allowClear: false,
                    data: motels
                }).prop('disabled', !isMotel);
                $('.inp-cbx[data-toggle="mlo-motel"]').prop('checked', isMotel);
            });

            $('.inp-cbx[data-toggle="mlo-__garage"]').prop('checked', false);
            $('.inp-cbx[data-toggle="mlo-__parking"]').prop('checked', false);
            $('input[name="mlo-garage_point"]').val('');
            if (house.metadata.garage) {
                $('.inp-cbx[data-toggle="mlo-__garage"]').prop('checked', true);
                $('input[name="mlo-garage_point"]').val(JSON.stringify(house.metadata.garage));
            }
            if (house.metadata.parking) {
                $('.inp-cbx[data-toggle="mlo-__parking"]').prop('checked', true);
                $('input[name="mlo-garage_point"]').val(JSON.stringify(house.metadata.parking));
            }
            
            HousingCreator.LoadMenusData({
                type: 'update-doors-list',
                value: house.metadata.doors
            })

            $('.inp-cbx[data-toggle="mlo-delivery_inside"]').prop('checked', house.metadata.deliveryType == 'inside');
            $('.inp-cbx[data-toggle="mlo-delivery_outside"]').prop('checked', house.metadata.deliveryType == 'outside');
            $('input[name="mlo-delivery_coordinates"]').val('');
            if (house.metadata.delivery) $('input[name="mlo-delivery_coordinates"]').val(JSON.stringify(house.metadata.delivery));
            
            $('.inp-cbx[data-toggle="mlo-furniture_environment_outside"]').prop('checked', house.metadata.allowFurnitureOutside);
            $('.inp-cbx[data-toggle="mlo-furniture_environment_inside"]').prop('checked', house.metadata.allowFurnitureInside);
            
            $('input[name="mlo-wardrobe_point"]').val('');
            if (house.metadata.wardrobe) {
                $('.inp-cbx[data-toggle="mlo-wardrobe"]').prop('checked', true);
                $('input[name="mlo-wardrobe_point"]').val(JSON.stringify(house.metadata.wardrobe));
            }

            $('input[name="mlo-storage_point"]').val('');
            if (house.metadata.storage) {
                $('.inp-cbx[data-toggle="mlo-storage"]').prop('checked', true);
                $('input[name="mlo-storage_point"]').val(JSON.stringify(house.metadata.storage));
                $('.mlo-storage input[name="metadata-slots-value"]').val(house.metadata.storage.slots).attr('disabled', false);
                $('.mlo-storage input[name="metadata-weight-value"]').val(house.metadata.storage.weight).attr('disabled', false);
            }
            
            $('input[name="mlo-keys_limit_count"]').val('');
            if (house.metadata.keysLimit) {
                $('.inp-cbx[data-toggle="mlo-keys_limit"]').prop('checked', true);
                $('input[name="mlo-keys_limit_count"]').val(house.metadata.keysLimit).prop('disabled', false);
            }
            
            $('input[name="mlo-permissions_limit_count"]').val('');
            if (house.metadata.permissionsLimit) {
                $('.inp-cbx[data-toggle="mlo-permissions_limit"]').prop('checked', true);
                $('input[name="mlo-permissions_limit_count"]').val(house.metadata.permissionsLimit).prop('disabled', false);
            }

            $('.inp-cbx[data-toggle="mlo-purchase_price"]').prop('checked', house.sale.active);
            $('input[name="mlo-purchase_price"]').val(house.sale.defaultPrice).attr('disabled', false);

            $('.inp-cbx[data-toggle="mlo-rent_price"]').prop('checked', house.rental.active);
            $('input[name="mlo-rent_price"]').val(house.rental.defaultPrice).attr('disabled', false);

            setTimeout(() => {
                checkMloInputs()
            }, 80);

        } else if (house.type == 'building') {
            // this.ResetBuilding();

            this.IsModifyingExisting = true;
            this.ModifyingIdentifier = house.id;

            $('.housing_creator div[data-type="configuration-building"] input[name="building-address"]').val(house.address);
            $('.housing_creator div[data-type="configuration-building"] input[name="building-region"]').val(house.region);
            $('.housing_creator div[data-type="configuration-building"] input[name="building-name"]').val(house.name);
            $('.housing_creator div[data-type="configuration-building"] input[name="building-yard_zone"]').val(JSON.stringify(house.metadata.zone));
            $('.housing_creator div[data-type="configuration-building"] input[name="building-enter_point"]').val(JSON.stringify(house.metadata.enter));
            $('.housing_creator div[data-type="configuration-building"] input[name="building-exit_point"]').val(JSON.stringify(house.metadata.exit));

            $('.inp-cbx[data-toggle="building-__underground_parking"]').prop('checked', house.metadata.parkingEnter != undefined)
            if (house.metadata.parkingEnter != undefined) {
                let floors = 0;
                for (const [floorId, floorData] of Object.entries(house.metadata.parkingSpaces)) {
                    floors += 1
                }
                $('.housing_creator div[data-type="configuration-building"] input[name="building-underground_parking_floors"]').val(floors).attr('disabled', false);
                $('.housing_creator div[data-type="configuration-building"] input[name="building-enter_garage_point"]').val(JSON.stringify(house.metadata.parkingEnter));
            }

        } else if (house.type == 'motel') {
            // this.ResetMotel();

            this.IsModifyingExisting = true;
            this.ModifyingIdentifier = house.id;
            
            $('.housing_creator div[data-type="configuration-motel"] input[name="motel-address"]').val(house.address);
            $('.housing_creator div[data-type="configuration-motel"] input[name="motel-region"]').val(house.region);
            $('.housing_creator div[data-type="configuration-motel"] input[name="motel-name"]').val(house.name);
            $('.housing_creator div[data-type="configuration-motel"] input[name="motel-yard_zone"]').val(JSON.stringify(house.metadata.zone));

        }
    },

    EditFurniture: function (model) {
        let furniture = null;
        for (const item of this.Pagination.Array) {
            if (item.model == model) {
                furniture = item;
                break;
            }
        }
        if (!furniture) return;

        $('.housing_creator div[data-type="configuration-furniture"] .metadata-list').hide();
        $('.housing_creator div[data-type="configuration-furniture"] .metadata-elements').empty();

        $('.housing_creator div[data-type="configuration-furniture"] .text > div > .save').addClass('allowed');
        $('.housing_creator div[data-type="configuration-furniture"] .text > div > .delete').show();
        $('.housing_creator div[data-type="configuration-furniture"] .mt-4 div[data-tag]').removeClass('active');

        updateSection('.housing_creator', 'configuration-furniture');
        
        this.IsModifyingExisting = true;
        this.ModifyingIdentifier = furniture.model;
        
        $('.housing_creator div[data-type="configuration-furniture"] img.furniture-image').attr('src', `./images/furniture/${furniture.model}.webp`);
        $('.housing_creator div[data-type="configuration-furniture"] p#furniture-model-name').text(furniture.model || "unknown");

        $('.housing_creator div[data-type="configuration-furniture"] input[name="furniture-label"]').val(furniture.label || "");

        $('.housing_creator div[data-type="configuration-furniture"] input[name="furniture-price"]').val(furniture.price || 0);

        if (furniture.tag && furniture.tag != "") {
            $(`.housing_creator div[data-type="configuration-furniture"] .mt-4 div[data-tag="${furniture.tag}"]`).addClass('active');
        }

        $('.inp-cbx[data-toggle="furniture-inside"]').prop('checked', furniture.isIndoor == true);
        $('.inp-cbx[data-toggle="furniture-outside"]').prop('checked', furniture.isOutdoor == true);

        $('.inp-cbx[data-toggle="furniture-delivery_small"]').prop('checked', furniture.deliverySize == 1);
        $('.inp-cbx[data-toggle="furniture-delivery_medium"]').prop('checked', furniture.deliverySize == 2);
        $('.inp-cbx[data-toggle="furniture-delivery_big"]').prop('checked', furniture.deliverySize == 3);

        $('.housing_creator div[data-type="configuration-furniture"] #interactable-name > .mt-2').html(`<select name="furniture-interactable-name"></select>`)

        const interactableElements = [];
        interactableElements.push({
            id: 0,
            text: 'none',
            selected: true
        })
     
        config.configuratorFurnitureInteractables.forEach(element => {
            interactableElements.push({
                id: element,
                text: config.interactableInfo[element] ? config.interactableInfo[element].label : element,
                selected: element == furniture.interactableName
            })
        });
        $('.housing_creator div[data-type="configuration-furniture"] span.select2-selection__rendered').attr('title', 'none').html('none');

        $('.housing_creator div[data-type="configuration-furniture"] select[name="furniture-interactable-name"]').select2({
            allowClear: false,
            data: interactableElements
        })
        
        if (furniture.metadata && furniture.interactableName && config.configuratorFurnitureMetadata[furniture.interactableName]) {
            let metadataElementsHTML = '';
        
            config.configuratorFurnitureMetadata[furniture.interactableName].forEach(element => {
                metadataElementsHTML += `
                    <input name="metadata-${element.key}-key" type="text" value="${element.key}" disabled>
                    <input name="metadata-${element.key}-value" type="${element.allowedValue || "text"}" value="${furniture.metadata[element.key]}">
                `
            });

            $('.housing_creator div[data-type="configuration-furniture"] .metadata-list').show();
            $('.housing_creator div[data-type="configuration-furniture"] .metadata-elements').html(metadataElementsHTML);
        }
    },

    LoadPagination: function (data) {
        this.Pagination.Array = Object.values(data);
    },

    ClearPagination: function (type) {
        if (!type) {
            this.Pagination.Array = [];
            this.Pagination.ArrayFiltered = [];
            this.Pagination.CurrentPage = 1;
            // this.Pagination.currentFilter = "all";
            this.Pagination.SearchTerm = "";

            $('.housing_creator .main > div[data-type="all-properties"] > .properties').empty();
            $('.housing_creator .main > div[data-type="all-furniture"] > .furniture').empty();

            return;
        }
    },
    
    UpdatePagination: function(type) {
        $(`.housing_creator .main > div[data-type="${type}"] #prev-page`).prop('disabled', this.Pagination.CurrentPage === 1);
        $(`.housing_creator .main > div[data-type="${type}"] #next-page`).prop('disabled', this.Pagination.CurrentPage === Math.ceil((this.Pagination.SearchTerm != "" ? this.Pagination.ArrayFiltered.length : this.Pagination.Array.length) / this.Pagination.ItemsPerPage));
    },

    RenderPagination: function(type) {
        $(`.housing_creator .main > div[data-type="${type}"] table > tbody`).empty();

        if (type == 'all-properties') {
            this.Pagination.ItemsPerPage = 13;
        } else if (type == 'all-furniture') {
            this.Pagination.ItemsPerPage = 7;
        }
        
        const start = (this.Pagination.CurrentPage - 1) * this.Pagination.ItemsPerPage;
        const end = start + this.Pagination.ItemsPerPage;
        let pageItems = this.Pagination.Array.slice(start, end);
        if (this.Pagination.SearchTerm != "") {
            pageItems = this.Pagination.ArrayFiltered.slice(start, end);
        }

        if (type == 'all-properties') {
            pageItems.forEach((item, index) => {
                $(`.housing_creator .main > div[data-type="${type}"] table > tbody`).append(`
                    <tr>
                        <td id="house_type">
                            <div id="${item.type}">${
                                item.type == 'shell' && "SHELL" ||
                                item.type == 'ipl' && "IPL" ||
                                item.type == 'mlo' && "MLO" ||
                                item.type == 'building' && "BUILDING" || 
                                item.type == 'motel' && "MOTEL" ||
                                item.type == 'apartment' && "APARTMENT" ||
                                item.type.toUpperCase()
                            }</div>
                        </td>
                        <td id="house_name">${item.name}</td>
                        <td id="house_address"> ${item.region ? `<span class="region">${item.region}</span><br>` : ''}<span class="address">${item.address}</span></td>
                        <td id="house_owner">
                            <div>
                                <div class="remove-owner" onclick="HousingCreator.RemoveOwner('${item.id}')">
                                    ${item.owner ? '<i class="fa-solid fa-trash-can"></i>' : ''}
                                </div>
                                <div>
                                    ${item.owner ? `<span class="owner">${item.owner}</span><br>` : ''}
                                    ${item.owner_name ? `<span class="owner_name">${item.owner_name}</span>` : ''}
                                </div>
                            </div>
                        </td>
                        <td id="house_renter">
                            <div>
                                <div class="remove-renter" onclick="HousingCreator.RemoveRenter('${item.id}')">
                                    ${item.renter ? '<i class="fa-solid fa-trash-can"></i>' : ''}
                                </div>
                                <div>
                                    ${item.renter ? `<span class="renter">${item.renter}</span><br>` : ''}
                                    ${item.renter_name ? `<span class="renter_name">${item.renter_name}</span>` : ''}
                                </div>
                            </div>
                        </td>
                        <td id="actions">
                            <div class="teleport" onclick="HousingCreator.TeleportToProperty('${item.id}')">
                                <i class="fa-solid fa-street-view"></i>
                            </div>
                            <div class="edit" onclick="HousingCreator.EditHouse('${item.id}')">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </div>
                        </td>
                    </tr>
                `);
            });

        } else if (type == 'all-furniture') {
            pageItems.forEach((item, index) => {
                $(`.housing_creator .main > div[data-type="${type}"] table > tbody`).append(`
                    <tr>
                        <td id="furniture_image">
                            <img src="./images/furniture/${item.model}.webp">
                        </td>
                        <td id="furniture_label">${item.label}</td>
                        <td id="furniture_price">${translation.currency}${formatNumber(item.price, 0, 0)}</td>
                        <td id="furniture_model">${item.model}</td>
                        <td id="furniture_category">${item.tag || ''}</td>
                        <td id="furniture_interactable">${item.interactableName || ''}</td>
                        <td id="actions">
                            <div class="edit" onclick="HousingCreator.EditFurniture('${item.model}')">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </div>
                        </td>
                    </tr>
                `);
            });
        }
        
        this.UpdatePagination(type);
        
        $(`.housing_creator .main > div[data-type="${type}"] #page-info`).text(this.Pagination.CurrentPage + '/' + Math.ceil((this.Pagination.SearchTerm != "" ? this.Pagination.ArrayFiltered.length : this.Pagination.Array.length) / this.Pagination.ItemsPerPage));
    },

    RefreshPropertiesMenu: function() {
        $.post(`https://${GetParentResourceName()}/creator:getAllProperties`, JSON.stringify({}), function (properties) {
            if ($('.housing_creator div[data-type="all-properties"]').css('display') === 'block') {
                HousingCreator.LoadPagination(properties);
                HousingCreator.RenderPagination('all-properties');
                HousingCreator.UpdatePagination('all-properties');
            }
        });
    }
}

$(document).on('click', '.housing_creator .menu ul > li', function(e) {
    let newMenu = $(this).data('href');
    updateSection('.housing_creator', newMenu, this);
})

$(document).on('click', '.housing_creator .menu div[data-type="new"] #housing_types > div', function(e) {
    let newMenu = $(this).data('housing-type');
    updateSection('.housing_creator', ((newMenu == 'building' || newMenu == 'motel' || newMenu == 'mlo') && `configuration-${newMenu}` || `new-${newMenu}`), this);
})



// ███╗   ██╗███████╗██╗    ██╗    ███████╗██╗  ██╗███████╗██╗     ██╗     
// ████╗  ██║██╔════╝██║    ██║    ██╔════╝██║  ██║██╔════╝██║     ██║     
// ██╔██╗ ██║█████╗  ██║ █╗ ██║    ███████╗███████║█████╗  ██║     ██║     
// ██║╚██╗██║██╔══╝  ██║███╗██║    ╚════██║██╔══██║██╔══╝  ██║     ██║     
// ██║ ╚████║███████╗╚███╔███╔╝    ███████║██║  ██║███████╗███████╗███████╗
// ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
$(document).on('click', '.housing_creator div[data-type="new-shell"] > div > .side-boxes > .box > .text .tags > div', function(e) {
    let newMenu = $(this).data('tag');

    $('.housing_creator div[data-type="new-shell"] > div > .side-boxes > .box > .text .tags > div').removeClass('active');

    $(this).addClass('active');

    if (newMenu == 'default') {
        $('.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>#shells-list > div').show();
        return
    }
    
    $('.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>#shells-list > div').hide();
    $(`.housing_creator div[data-type="new-shell"]>div>.side-boxes>.box>#shells-list > div.tag-${newMenu}`).show();
})

$(document).on('click', '.housing_creator div[data-type="new-shell"] > div > .side-boxes > .box > #shells-list > div > .buttons > #select-shell', function(e) {
    let selectedShell = $(this).data('shell');
    $.post(`https://${GetParentResourceName()}/creator:selectShell`, JSON.stringify({shell: selectedShell}));
    
    if (HousingCreator.IsModifyingExisting) {
        updateSection('.housing_creator', 'configuration-shell');
        HousingCreator.IsModifyingExisting = true;
        $(`.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box > .options .mt-2 > input[name="shell-name"]`).val(selectedShell)
    } else {
        updateSection('.housing_creator', 'configuration-shell');
        HousingCreator.ConfigurationShell(selectedShell);
    }
})

$(document).on('click', '.housing_creator div[data-type="new-shell"] > div > .side-boxes > .box > #shells-list > div > .buttons > #preview-shell', function(e) {
    let selectedShell = $(this).data('shell');
    $.post(`https://${GetParentResourceName()}/creator:previewShell`, JSON.stringify({shell: selectedShell}));
});

$(document).on('click', '.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-floors > div', function(e) {
    if (!usingVMSGarages) return;
    
    let floor = $(this).data('floor');

    $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-floors > div').removeClass('active');
    
    $(this).addClass('active');
    
    let parkingSpacesHTML = '';
    for (let i=1; i <= 38; i++) {
        const inputId = `shell-parking_space_${i}`;

        const parkingOwner = HousingCreator.BuildingParking[String(floor)][String(i)];
        const isBlocked = (
            (!HousingCreator.ModifyingIdentifier && parkingOwner) ||
            (HousingCreator.ModifyingIdentifier && parkingOwner && parkingOwner !== HousingCreator.ModifyingIdentifier)
        );

        parkingSpacesHTML += `
            <div class="checkbox-wrapper-46 ${isBlocked ? 'not-allowed' : ''}">
                <input
                    type="checkbox"
                    id="${inputId}"
                    class="inp-cbx ${isBlocked ? 'not-allowed' : ''}"
                    data-toggle="shell-parking_space"
                    data-floor="${floor}"
                    data-parking-space="${i}"
                    ${HousingCreator.ApartmentParkingSpots[String(floor)] && HousingCreator.ApartmentParkingSpots[String(floor)].includes(String(i)) && 'checked' || ''}
                >
                <label for="${inputId}" class="cbx">
                    <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                    <label for="${inputId}" class="input-name">#${i}</label>
                </label>
            </div>
        `
    }

    $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-spaces').html(parkingSpacesHTML);
});

$(document).on('click', '.housing_creator div[data-type="configuration-shell"] > div > .side-boxes > .box > .options .inp-cbx', function(e) {
    let toggle = $(this).data('toggle');
    let isChecked = $(this).prop('checked');

    if ($(this).hasClass('not-allowed')) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $(this).prop('checked', isChecked);
        return false;
    };

    if (toggle == "shell-delivery_inside") {
        $('.inp-cbx[data-toggle="shell-delivery_outside"]').prop('checked', false);
        $('input[name="shell-delivery_coordinates"]').attr('value', '');
        
    } else if (toggle == "shell-delivery_outside") {
        $('.inp-cbx[data-toggle="shell-delivery_inside"]').prop('checked', false);
        $('input[name="shell-delivery_coordinates"]').attr('value', '');
        
    } else if (toggle == "shell-building") {
        $('.inp-cbx[data-toggle="shell-motel"]').prop('checked', false);
        $('.housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2 > select').prop('disabled', true);
        $('.housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2 > select').prop('disabled', !isChecked);
        
    } else if (toggle == "shell-motel") {
        $('.inp-cbx[data-toggle="shell-building"]').prop('checked', false);
        $('.housing_creator div[data-type="configuration-shell"] .shell-building > .mt-2 > select').prop('disabled', true);
        $('.housing_creator div[data-type="configuration-shell"] .shell-motel > .mt-2 > select').prop('disabled', !isChecked);
        
    } else if (toggle == "shell-storage") {
        $('.housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-slots-value"]').prop('disabled', !isChecked);
        $('.housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-weight-value"]').prop('disabled', !isChecked);
        
    } else if (toggle == "shell-keys_limit") {
        $('.housing_creator div[data-type="configuration-shell"] input[name="shell-keys_limit_count"]').prop('disabled', !isChecked);

    } else if (toggle == "shell-permissions_limit") {
        $('.housing_creator div[data-type="configuration-shell"] input[name="shell-permissions_limit_count"]').prop('disabled', !isChecked);
        
    } else if (toggle == "shell-__garage") {
        $('.inp-cbx[data-toggle="shell-__parking"]').prop('checked', false);
        $('input[name="shell-garage_point"]').attr('value', '');

    } else if (toggle == "shell-__parking") {
        $('.inp-cbx[data-toggle="shell-__garage"]').prop('checked', false);
        $('input[name="shell-garage_point"]').attr('value', '');

    }
    
    if (toggle.includes('shell-parking_space')) {
        let floor = $(this).data('floor');
        let parkingSpace = $(this).data('parking-space');

        if (!HousingCreator.ApartmentParkingSpots[String(floor)]) {
            HousingCreator.ApartmentParkingSpots[String(floor)] = []
        }

        if (isChecked) {
            HousingCreator.ApartmentParkingSpots[String(floor)].push(String(parkingSpace))
        } else {
            HousingCreator.ApartmentParkingSpots[String(floor)] = HousingCreator.ApartmentParkingSpots[String(floor)].filter(value => value !== String(parkingSpace));
        }

        // $(`.housing_creator div[data-type="configuration-shell"] > div > .side-boxes > .box > .options input[name="${toggle}"][data-parking-space="${parkingSpace}"]`).prop('disabled', !isChecked);
    } else {
        $(`.housing_creator div[data-type="configuration-shell"] > div > .side-boxes > .box > .options input[name="${toggle}"]`).prop('disabled', !isChecked);
    }
});

$(document).on('click', '.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box > .options .mt-2 > .button', function(e) {
    if ($(this).hasClass('not-allowed')) return;

    let buttonAction = $(this).data('button-action');
    if (!buttonAction) return;
    
    let jsonData = {
        type: 'shell',
        action: buttonAction.replace(/^shell-?/, "")
    }

    if (buttonAction == "shell-delivery_coordinates") {
        jsonData.isInside = $('.inp-cbx[data-toggle="shell-delivery_inside"]').prop('checked');
        jsonData.isOutside = $('.inp-cbx[data-toggle="shell-delivery_outside"]').prop('checked');
        if (!jsonData.isInside && !jsonData.isOutside) return;
        
    } else if (buttonAction == "shell-emergency_exit_outside" || buttonAction == "shell-emergency_exit_inside") {
        let isEmergencyExitActive = $('.inp-cbx[data-toggle="shell-emergency_exit"]').prop('checked');
        if (!isEmergencyExitActive) return;

    } else if (buttonAction == "shell-garage_point") {
        jsonData.isGarage = $('.inp-cbx[data-toggle="shell-__garage"]').prop('checked');
        jsonData.isParking = $('.inp-cbx[data-toggle="shell-__parking"]').prop('checked');
        if (!jsonData.isGarage && !jsonData.isParking) return;

    } else if (buttonAction == "shell-wardrobe_point") {
        let isWardrobeActive = $('.inp-cbx[data-toggle="shell-wardrobe"]').prop('checked');
        if (!isWardrobeActive) return;

    } else if (buttonAction == "shell-storage_point") {
        let isStorageActive = $('.inp-cbx[data-toggle="shell-storage"]').prop('checked');
        if (!isStorageActive) return;

    } else if (buttonAction == "shell-name") {
        HousingCreator.LoadMenusData({
            type: 'new-shell'
        });
        updateSection('.housing_creator', 'new-shell');
        HousingCreator.IsModifyingExisting = true;
        $('.housing_creator div[data-type="configuration-shell"]').hide();
        return;
        
    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-shell"] .text > div > .save.allowed', function(e) {
    let jsonData = {
        type: 'shell',
        action: 'save'
    }
    
    if (HousingCreator.IsModifyingExisting) {
        jsonData.isModifying = HousingCreator.ModifyingIdentifier;
    }

    let isBuilding = $('.inp-cbx[data-toggle="shell-building"]').prop("checked")
    if (isBuilding) {
        let building = $('.housing_creator div[data-type="configuration-shell"] .shell-building select').select2('data')[0]
        if (building != "0") {
            jsonData.building = building.id;
            if (jsonData.building && HousingCreator.BuildingParkingId && usingVMSGarages) {
                jsonData.parkingSpaces = HousingCreator.ApartmentParkingSpots;
            }
        }
    }

    let isMotel = $('.inp-cbx[data-toggle="shell-motel"]').prop("checked")
    if (isMotel) {
        let motel = $('.housing_creator div[data-type="configuration-shell"] .shell-motel select').select2('data')[0]
        if (motel != "0") {
            jsonData.motel = motel.id;
        }
    }
    
    jsonData.houseName = $('input[name="shell-house_name"]').val();
    jsonData.houseDescription = $('textarea[name="shell-house_description"]').val();
    
    jsonData.isDeliveryInside = $('.inp-cbx[data-toggle="shell-delivery_inside"]').prop('checked');
    jsonData.isDeliveryOutside = $('.inp-cbx[data-toggle="shell-delivery_outside"]').prop('checked');
    
    jsonData.allowFurnitureOutside = $('.inp-cbx[data-toggle="shell-furniture_environment_outside"]').prop('checked');
    jsonData.allowFurnitureInside = $('.inp-cbx[data-toggle="shell-furniture_environment_inside"]').prop('checked');
    
    jsonData.isEmergencyExit = $('.inp-cbx[data-toggle="shell-emergency_exit"]').prop('checked');

    jsonData.isGarage = $('.inp-cbx[data-toggle="shell-__garage"]').prop('checked');
    jsonData.isParking = $('.inp-cbx[data-toggle="shell-__parking"]').prop('checked');
    
    jsonData.isWardrobe = $('.inp-cbx[data-toggle="shell-wardrobe"]').prop('checked');
    jsonData.isStorage = $('.inp-cbx[data-toggle="shell-storage"]').prop('checked');
    jsonData.storageSlots = $('.housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-slots-value"]').val();
    jsonData.storageWeight = $('.housing_creator div[data-type="configuration-shell"] .shell-storage .metadata-elements > input[name="metadata-weight-value"]').val();
    
    jsonData.isPurchase = $('.inp-cbx[data-toggle="shell-purchase_price"]').prop('checked');
    jsonData.purchasePrice = getRawValue('input[name="shell-purchase_price"]');
    
    jsonData.isRent = $('.inp-cbx[data-toggle="shell-rent_price"]').prop('checked');
    jsonData.rentPrice = getRawValue('input[name="shell-rent_price"]');

    jsonData.isKeysLimit = $('.inp-cbx[data-toggle="shell-keys_limit"]').prop('checked');
    jsonData.keysLimit = $('input[name="shell-keys_limit_count"]').val();
    
    jsonData.isPermissionsLimit = $('.inp-cbx[data-toggle="shell-permissions_limit"]').prop('checked');
    jsonData.permissionsLimit = $('input[name="shell-permissions_limit_count"]').val();
    
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-shell"] .text > div > .delete', function(e) {
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'shell',
        action: 'delete',
        id: HousingCreator.ModifyingIdentifier
    }));
    updateSection('.housing_creator', 'all-properties');
})

function checkShellInputs() {
    let building = $('.housing_creator div[data-type="configuration-shell"] .shell-building select').select2('data')[0]
    let buildingClasses = $(`
        input[name="shell-yard_zone"],
        .button[data-button-action="shell-yard_zone"],

        input[name="shell-enter_point"],
        .button[data-button-action="shell-enter_point"],

        input[name="shell-exit_point"],
        .button[data-button-action="shell-exit_point"],

        label[for="shell-delivery_outside"],
        input[data-toggle="shell-delivery_outside"],
        
        label[for="shell-furniture_environment_outside"],
        input[data-toggle="shell-furniture_environment_outside"],

        label[for="shell-__garage"],
        input[data-toggle="shell-__garage"],

        label[for="shell-__parking"],
        input[data-toggle="shell-__parking"],

        input[name="shell-garage_point"],
        .button[data-button-action="shell-garage_point"]
    `);

    let motel = $('.housing_creator div[data-type="configuration-shell"] .shell-motel select').select2('data')[0]
    let motelClasses = $(`
        input[name="shell-yard_zone"],
        .button[data-button-action="shell-yard_zone"],

        label[for="shell-delivery_outside"],
        input[data-toggle="shell-delivery_outside"],
        
        label[for="shell-furniture_environment_outside"],
        input[data-toggle="shell-furniture_environment_outside"],

        label[for="shell-__garage"],
        input[data-toggle="shell-__garage"],
        
        label[for="shell-__parking"],
        input[data-toggle="shell-__parking"],

        input[name="shell-garage_point"],
        .button[data-button-action="shell-garage_point"]
    `);

    let isApartment = false;
    let isMotel = false;
    if ($("#shell-building").is(":checked")) {
        motelClasses.removeClass('not-allowed');
        if (building.id != '0') {
            if (HousingCreator.BuildingParkingId != building.id && usingVMSGarages) {
                $.post(`https://${GetParentResourceName()}/creator:getBuildingParking`, JSON.stringify({ id: building.id }), function (parking) {
                    if (parking) {
                        HousingCreator.BuildingParkingId = building.id;
                        HousingCreator.BuildingParking = parking;
                        let parkingFloors = 0;
                        let parkingFloorsHTML = '';
                        for (const [floor, _] of Object.entries(HousingCreator.BuildingParking)) {
                            parkingFloors += 1;
                            parkingFloorsHTML += `<div data-floor="${floor}" ${floor === "1" ? 'class="active"': ''}>${(translation.creator.configuration_shell['option:label.parking_space_floor']).format(floor)}</div>`;
                        }
                        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-floors').html(parkingFloorsHTML).css('grid-template-columns', `repeat(${parkingFloors}, 1fr)`);

                        let parkingSpacesHTML = '';
                        for (let i=1; i <= 38; i++) {
                            const inputId = `shell-parking_space_${i}`;

                            const parkingOwner = HousingCreator.BuildingParking["1"][String(i)];
                            const isBlocked = (
                                (!HousingCreator.ModifyingIdentifier && parkingOwner) ||
                                (HousingCreator.ModifyingIdentifier && parkingOwner && parkingOwner !== HousingCreator.ModifyingIdentifier)
                            );

                            parkingSpacesHTML += `
                                <div class="checkbox-wrapper-46 ${isBlocked ? 'not-allowed' : ''}">
                                    <input
                                        type="checkbox"
                                        id="${inputId}"
                                        class="inp-cbx ${isBlocked ? 'not-allowed' : ''}"
                                        data-toggle="shell-parking_space"
                                        data-floor="${1}"
                                        data-parking-space="${i}"
                                        ${HousingCreator.ModifyingIdentifier ? (parkingOwner === HousingCreator.ModifyingIdentifier ? 'checked' : '') : ''}
                                    >
                                    <label for="${inputId}" class="cbx">
                                        <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                                        <label for="${inputId}" class="input-name">#${i}</label>
                                    </label>
                                </div>
                            `
                        }
                        
                        HousingCreator.ApartmentParkingSpots = {}
                        if (HousingCreator.ModifyingIdentifier) {
                            for (const [floor, floorData] of Object.entries(HousingCreator.BuildingParking)) {
                                for (const [spot, apartment] of Object.entries(floorData)) {
                                    if (String(apartment) === String(HousingCreator.ModifyingIdentifier)) {
                                        if (!HousingCreator.ApartmentParkingSpots[String(floor)]) {
                                            HousingCreator.ApartmentParkingSpots[String(floor)] = []
                                        }
                                        HousingCreator.ApartmentParkingSpots[String(floor)].push(String(spot))
                                    }
                                }
                            }
                        }
                        
                        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space').show();
                        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-spaces').html(parkingSpacesHTML);
                    } else {
                        HousingCreator.BuildingParkingId = null;
                        HousingCreator.BuildingParking = null;
                        HousingCreator.ApartmentParkingSpots = null;
                        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space').hide();
                        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-spaces').empty();
                    }
                });
            }

            isApartment = true;
            buildingClasses.addClass('not-allowed');
            $('input[data-toggle="shell-delivery_outside"]').prop('checked', false);
            $('input[data-toggle="shell-furniture_environment_outside"]').prop('checked', false);
            $('input[data-toggle="shell-__garage"]').prop('checked', false);
            $('input[data-toggle="shell-__parking"]').prop('checked', false);
        } else {
            buildingClasses.removeClass('not-allowed');
        }
        
    } else if ($("#shell-motel").is(":checked")) {
        buildingClasses.removeClass('not-allowed');
        if (motel.id != '0') {
            isMotel = true;
            motelClasses.addClass('not-allowed');
            $('input[data-toggle="shell-delivery_outside"]').prop('checked', false);
            $('input[data-toggle="shell-furniture_environment_outside"]').prop('checked', false);
            $('input[data-toggle="shell-__garage"]').prop('checked', false);
            $('input[data-toggle="shell-__parking"]').prop('checked', false);
        } else {
            motelClasses.removeClass('not-allowed');
        }
        
    } else {
        if (!$("#shell-motel").is(":checked")) {
            buildingClasses.removeClass('not-allowed');
        }
        if (!$("#shell-building").is(":checked")) {
            motelClasses.removeClass('not-allowed');
            HousingCreator.BuildingParking = null;
            HousingCreator.BuildingParkingId = null;
        }
    }

    if (!isApartment) {
        HousingCreator.BuildingParkingId = null;
        HousingCreator.BuildingParking = null;
        HousingCreator.ApartmentParkingSpots = null;
        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space').hide();
        $('.housing_creator div[data-type="configuration-shell"]>div>.side-boxes>.box>.options .shell-parking_space > .parking-spaces').empty();
    }

    let inputs = $(`
        input[name='shell-name'], 
        input[name='shell-address'], 
        input[name='shell-region'], 
        input[name='shell-house_name'], 
        input[name='shell-yard_zone'], 
        input[name='shell-enter_point'], 
        input[name='shell-exit_point']
    `);

    if (isApartment) {
        inputs = $(`
            input[name='shell-name'], 
            input[name='shell-address'], 
            input[name='shell-region'], 
            input[name='shell-house_name']
        `);
    }
    
    if (isMotel) {
        inputs = $(`
            input[name='shell-name'], 
            input[name='shell-address'], 
            input[name='shell-region'], 
            input[name='shell-house_name'], 
            input[name='shell-enter_point'], 
            input[name='shell-exit_point']
        `);
    }
    
    let values = inputs.map(function () {
        return $(this).val().trim();
    }).get();

    if ($("#shell-building").is(":checked")) {
        if (building.id == '0') {
            values.push("");
        }
    }

    if ($("#shell-motel").is(":checked")) {
        if (motel.id == '0') {
            values.push("");
        }
    }

    if (!isApartment && !isMotel) {
        if ($("#shell-__garage").is(":checked") || $("#shell-__parking").is(":checked")) {
            values.push($("input[name='shell-garage_point']").val().trim());
        }
    }

    if ($("#shell-purchase_price").is(":checked")) {
        values.push($("input[name='shell-purchase_price']").val().trim());
    }
    
    if ($("#shell-rent_price").is(":checked")) {
        values.push($("input[name='shell-rent_price']").val().trim());
    }

    if ($("#shell-keys_limit").is(":checked")) {
        values.push($("input[name='shell-keys_limit_count']").val().trim());
    }
    
    if ($("#shell-permissions_limit").is(":checked")) {
        values.push($("input[name='shell-permissions_limit_count']").val().trim());
    }

    const hasEmpty = values.includes("") || values.includes(undefined);

    if (hasEmpty) {
        $('.housing_creator div[data-type="configuration-shell"] .text > div > .save').removeClass("allowed");
    } else {
        $('.housing_creator div[data-type="configuration-shell"] .text > div > .save').addClass("allowed");
    }
}
$(`
    .housing_creator div[data-type="configuration-shell"] .mt-2 > input,
    input#shell-building,
    input#shell-motel,
    input#shell-__garage,
    input#shell-__parking,
    input#shell-delivery_inside,
    input#shell-delivery_outside,
    input#shell-purchase_price,
    input#shell-rent_price,
    input#shell-keys_limit,
    input#shell-permissions_limit
`).on("input change", checkShellInputs);
$('.housing_creator div[data-type="configuration-shell"]').on('select2:select', 'select', checkShellInputs);



// ███╗   ██╗███████╗██╗    ██╗    ██╗██████╗ ██╗     
// ████╗  ██║██╔════╝██║    ██║    ██║██╔══██╗██║     
// ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║██████╔╝██║     
// ██║╚██╗██║██╔══╝  ██║███╗██║    ██║██╔═══╝ ██║     
// ██║ ╚████║███████╗╚███╔███╔╝    ██║██║     ███████╗
// ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚═╝╚═╝     ╚══════╝
$(document).on('click', '.housing_creator div[data-type="new-ipl"] > div > .side-boxes > .box > .text .tags > div', function(e) {
    let newMenu = $(this).data('tag');

    $('.housing_creator div[data-type="new-ipl"] > div > .side-boxes > .box > .text .tags > div').removeClass('active');

    $(this).addClass('active');

    if (newMenu == 'default') {
        $('.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>#ipls-list > div').show();
        return
    }
    
    $('.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>#ipls-list > div').hide();
    $(`.housing_creator div[data-type="new-ipl"]>div>.side-boxes>.box>#ipls-list > div.tag-${newMenu}`).show();
})

$(document).on('click', '.housing_creator div[data-type="new-ipl"] > div > .side-boxes > .box > #ipls-list > div > .buttons > #select-ipl', function(e) {
    let selectedIPL = $(this).data('ipl');
    $.post(`https://${GetParentResourceName()}/creator:selectIPL`, JSON.stringify({ipl: selectedIPL}));
    
    if (HousingCreator.IsModifyingExisting) {
        updateSection('.housing_creator', 'configuration-ipl');
        HousingCreator.IsModifyingExisting = true;
        $(`.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box > .options .mt-2 > input[name="ipl-name"]`).attr('value', selectedIPL)
    } else {
        updateSection('.housing_creator', 'configuration-ipl');
        HousingCreator.ConfigurationIPL(selectedIPL);
    }
})

$(document).on('click', '.housing_creator div[data-type="new-ipl"] > div > .side-boxes > .box > #ipls-list > div > .buttons > #preview-ipl', function(e) {
    let selectedIPL = $(this).data('ipl');
    $.post(`https://${GetParentResourceName()}/creator:previewIPL`, JSON.stringify({ipl: selectedIPL}));
});

$(document).on('click', '.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-floors > div', function(e) {
    if (!usingVMSGarages) return;

    let floor = $(this).data('floor');

    $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-floors > div').removeClass('active');
    
    $(this).addClass('active');
    
    let parkingSpacesHTML = '';

    for (let i=1; i <= 38; i++) {
        const inputId = `ipl-parking_space_${i}`;

        const parkingOwner = HousingCreator.BuildingParking[String(floor)][String(i)];
        const isBlocked = (
            (!HousingCreator.ModifyingIdentifier && parkingOwner) ||
            (HousingCreator.ModifyingIdentifier && parkingOwner && parkingOwner !== HousingCreator.ModifyingIdentifier)
        );

        parkingSpacesHTML += `
            <div class="checkbox-wrapper-46 ${isBlocked ? 'not-allowed' : ''}">
                <input
                    type="checkbox"
                    id="${inputId}"
                    class="inp-cbx ${isBlocked ? 'not-allowed' : ''}"
                    data-toggle="ipl-parking_space"
                    data-floor="${floor}"
                    data-parking-space="${i}"
                    ${HousingCreator.ApartmentParkingSpots[String(floor)] && HousingCreator.ApartmentParkingSpots[String(floor)].includes(String(i)) && 'checked' || ''}
                >
                <label for="${inputId}" class="cbx">
                    <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                    <label for="${inputId}" class="input-name">#${i}</label>
                </label>
            </div>
        `
    }

    $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-spaces').html(parkingSpacesHTML);
});

$(document).on('click', '.housing_creator div[data-type="configuration-ipl"] > div > .side-boxes > .box > .options > div .inp-cbx', function(e) {
    let toggle = $(this).data('toggle');
    let isChecked = $(this).prop('checked');
    
    if ($(this).hasClass('not-allowed')) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $(this).prop('checked', isChecked);
        return false;
    };

    if (toggle == "ipl-delivery_inside") {
        $('.inp-cbx[data-toggle="ipl-delivery_outside"]').prop('checked', false);
        $('input[name="ipl-delivery_coordinates"]').attr('value', '');

    } else if (toggle == "ipl-delivery_outside") {
        $('.inp-cbx[data-toggle="ipl-delivery_inside"]').prop('checked', false);
        $('input[name="ipl-delivery_coordinates"]').attr('value', '');
        
    } else if (toggle == "ipl-__garage") {
        $('.inp-cbx[data-toggle="ipl-__parking"]').prop('checked', false);
        $('input[name="ipl-garage_point"]').attr('value', '');
        
    } else if (toggle == "ipl-__parking") {
        $('.inp-cbx[data-toggle="ipl-__garage"]').prop('checked', false);
        $('input[name="ipl-garage_point"]').attr('value', '');
                
    } else if (toggle == "ipl-building") {
        $('.inp-cbx[data-toggle="ipl-motel"]').prop('checked', false);
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2 > select').prop('disabled', true);
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2 > select').prop('disabled', !isChecked);
        
    } else if (toggle == "ipl-motel") {
        $('.inp-cbx[data-toggle="ipl-building"]').prop('checked', false);
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-building > .mt-2 > select').prop('disabled', true);
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel > .mt-2 > select').prop('disabled', !isChecked);

    } else if (toggle == "ipl-storage") {
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-slots-value"]').prop('disabled', !isChecked);
        $('.housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-weight-value"]').prop('disabled', !isChecked);
        
    } else if (toggle == "ipl-keys_limit") {
        $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-keys_limit_count"]').prop('disabled', !isChecked);

    } else if (toggle == "ipl-permissions_limit") {
        $('.housing_creator div[data-type="configuration-ipl"] input[name="ipl-permissions_limit_count"]').prop('disabled', !isChecked);
        
    }
    
    if (toggle.includes('ipl-parking_space')) {
        let floor = $(this).data('floor');
        let parkingSpace = $(this).data('parking-space');

        if (!HousingCreator.ApartmentParkingSpots[String(floor)]) {
            HousingCreator.ApartmentParkingSpots[String(floor)] = []
        }

        if (isChecked) {
            HousingCreator.ApartmentParkingSpots[String(floor)].push(String(parkingSpace))
        } else {
            HousingCreator.ApartmentParkingSpots[String(floor)] = HousingCreator.ApartmentParkingSpots[String(floor)].filter(value => value !== String(parkingSpace));
        }

        $(`.housing_creator div[data-type="configuration-ipl"] > div > .side-boxes > .box > .options input[name="${toggle}"][data-parking-space="${parkingSpace}"]`).prop('disabled', !isChecked);
    } else {
        $(`.housing_creator div[data-type="configuration-ipl"] > div > .side-boxes > .box > .options input[name="${toggle}"]`).prop('disabled', !isChecked);
    }
});

$(document).on('click', '.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box > .options .mt-2 > .button', function(e) {
    if ($(this).hasClass('not-allowed')) return;

    let buttonAction = $(this).data('button-action');
    if (!buttonAction) return;
    
    let jsonData = {
        type: 'ipl',
        action: buttonAction.replace(/^ipl-?/, "")
    }

    if (buttonAction == "ipl-delivery_coordinates") {
        let themeName = $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme select').select2('data')[0]
        jsonData.houseTheme = themeName.id
        
        jsonData.isInside = $('.inp-cbx[data-toggle="ipl-delivery_inside"]').prop('checked');
        jsonData.isOutside = $('.inp-cbx[data-toggle="ipl-delivery_outside"]').prop('checked');
        if (!jsonData.isInside && !jsonData.isOutside) return;
        
    } else if (buttonAction == "ipl-emergency_exit_outside" || buttonAction == "ipl-emergency_exit_inside") {
        let isEmergencyExitActive = $('.inp-cbx[data-toggle="ipl-emergency_exit"]').prop('checked');
        if (!isEmergencyExitActive) return;

    } else if (buttonAction == "ipl-garage_point") {
        jsonData.isGarage = $('.inp-cbx[data-toggle="ipl-__garage"]').prop('checked');
        jsonData.isParking = $('.inp-cbx[data-toggle="ipl-__parking"]').prop('checked');
        if (!jsonData.isGarage && !jsonData.isParking) return;

    } else if (buttonAction == "ipl-wardrobe_point") {
        let themeName = $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme select').select2('data')[0]
        jsonData.houseTheme = themeName.id

        let isWardrobeActive = $('.inp-cbx[data-toggle="ipl-wardrobe"]').prop('checked');
        if (!isWardrobeActive) return;

    } else if (buttonAction == "ipl-storage_point") {
        let themeName = $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme select').select2('data')[0]
        jsonData.houseTheme = themeName.id

        let isStorageActive = $('.inp-cbx[data-toggle="ipl-storage"]').prop('checked');
        if (!isStorageActive) return;

    } else if (buttonAction == "ipl-name") {
        HousingCreator.LoadMenusData({
            type: 'new-ipl'
        });
        updateSection('.housing_creator', 'new-ipl');
        HousingCreator.IsModifyingExisting = true;
        $('.housing_creator div[data-type="configuration-ipl"]').hide();
        return;
        
    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-ipl"] .text > div > .save.allowed', function(e) {
    let jsonData = {
        type: 'ipl',
        action: 'save'
    }
    
    if (HousingCreator.IsModifyingExisting) {
        jsonData.isModifying = HousingCreator.ModifyingIdentifier;
    }
    
    let isBuilding = $('.inp-cbx[data-toggle="ipl-building"]').prop("checked")
    if (isBuilding) {
        let building = $('.housing_creator div[data-type="configuration-ipl"] .ipl-building select').select2('data')[0]
        if (building != "0") {
            jsonData.building = building.id;
            if (jsonData.building && HousingCreator.BuildingParkingId && usingVMSGarages) {
                jsonData.parkingSpaces = HousingCreator.ApartmentParkingSpots;
            }
        }
    }

    let themeName = $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme select').select2('data')[0]
    jsonData.houseTheme = themeName.id
    jsonData.allowChangeTheme = $('.inp-cbx[data-toggle="ipl-__theme_purchase_change"]').prop('checked');
    jsonData.allowChangeThemePurchased = $('.inp-cbx[data-toggle="ipl-__theme_purchased_change"]').prop('checked');
    
    jsonData.houseName = $('input[name="ipl-house_name"]').val();
    jsonData.houseDescription = $('textarea[name="ipl-house_description"]').val();
    
    jsonData.isDeliveryInside = $('.inp-cbx[data-toggle="ipl-delivery_inside"]').prop('checked');
    jsonData.isDeliveryOutside = $('.inp-cbx[data-toggle="ipl-delivery_outside"]').prop('checked');
    
    jsonData.allowFurnitureOutside = $('.inp-cbx[data-toggle="ipl-furniture_environment_outside"]').prop('checked');
    jsonData.allowFurnitureInside = $('.inp-cbx[data-toggle="ipl-furniture_environment_inside"]').prop('checked');
    
    jsonData.isEmergencyExit = $('.inp-cbx[data-toggle="ipl-emergency_exit"]').prop('checked');

    jsonData.isGarage = $('.inp-cbx[data-toggle="ipl-__garage"]').prop('checked');
    jsonData.isParking = $('.inp-cbx[data-toggle="ipl-__parking"]').prop('checked');

    jsonData.isWardrobe = $('.inp-cbx[data-toggle="ipl-wardrobe"]').prop('checked');
    jsonData.isStorage = $('.inp-cbx[data-toggle="ipl-storage"]').prop('checked');
    jsonData.storageSlots = $('.housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-slots-value"]').val();
    jsonData.storageWeight = $('.housing_creator div[data-type="configuration-ipl"] .ipl-storage .metadata-elements > input[name="metadata-weight-value"]').val();
    
    jsonData.isPurchase = $('.inp-cbx[data-toggle="ipl-purchase_price"]').prop('checked');
    jsonData.purchasePrice = getRawValue('input[name="ipl-purchase_price"]');
    
    jsonData.isRent = $('.inp-cbx[data-toggle="ipl-rent_price"]').prop('checked');
    jsonData.rentPrice = getRawValue('input[name="ipl-rent_price"]');
    
    jsonData.isKeysLimit = $('.inp-cbx[data-toggle="ipl-keys_limit"]').prop('checked');
    jsonData.keysLimit = $('input[name="ipl-keys_limit_count"]').val();
    
    jsonData.isPermissionsLimit = $('.inp-cbx[data-toggle="ipl-permissions_limit"]').prop('checked');
    jsonData.permissionsLimit = $('input[name="ipl-permissions_limit_count"]').val();

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-ipl"] .text > div > .delete', function(e) {
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'ipl',
        action: 'delete',
        id: HousingCreator.ModifyingIdentifier
    }));
    updateSection('.housing_creator', 'all-properties');
})

function checkIplInputs() {
    let building = $('.housing_creator div[data-type="configuration-ipl"] .ipl-building select').select2('data')[0]
    let buildingClasses = $(`
        input[name="ipl-yard_zone"],
        .button[data-button-action="ipl-yard_zone"],

        input[name="ipl-enter_point"],
        .button[data-button-action="ipl-enter_point"],

        input[name="ipl-exit_point"],
        .button[data-button-action="ipl-exit_point"],

        label[for="ipl-delivery_outside"],
        input[data-toggle="ipl-delivery_outside"],

        label[for="ipl-furniture_environment_outside"],
        input[data-toggle="ipl-furniture_environment_outside"],

        label[for="ipl-__garage"],
        input[data-toggle="ipl-__garage"],
        
        label[for="ipl-__parking"],
        input[data-toggle="ipl-__parking"],

        input[name="ipl-garage_point"],
        .button[data-button-action="ipl-garage_point"]
    `);

    let motel = $('.housing_creator div[data-type="configuration-ipl"] .ipl-motel select').select2('data')[0]
    let motelClasses = $(`
        input[name="ipl-yard_zone"],
        .button[data-button-action="ipl-yard_zone"],

        label[for="ipl-delivery_outside"],
        input[data-toggle="ipl-delivery_outside"],
        
        label[for="ipl-furniture_environment_outside"],
        input[data-toggle="ipl-furniture_environment_outside"],

        label[for="ipl-__garage"],
        input[data-toggle="ipl-__garage"],
        
        label[for="ipl-__parking"],
        input[data-toggle="ipl-__parking"],

        input[name="ipl-garage_point"],
        .button[data-button-action="ipl-garage_point"]
    `);

    let isApartment = false;
    let isMotel = false;
    if ($("#ipl-building").is(":checked")) {
        if (building.id != '0') {
            if (building.isMenuBuilding) {
                if (HousingCreator.BuildingParkingId != building.id && usingVMSGarages) {
                    $.post(`https://${GetParentResourceName()}/creator:getBuildingParking`, JSON.stringify({ id: building.id }), function (parking) {
                        if (parking) {
                            HousingCreator.BuildingParkingId = building.id;
                            HousingCreator.BuildingParking = parking;
                            let parkingFloors = 0;
                            let parkingFloorsHTML = '';
                            for (const [floor, _] of Object.entries(HousingCreator.BuildingParking)) {
                                parkingFloors += 1;
                                parkingFloorsHTML += `<div data-floor="${floor}" ${floor === "1" ? 'class="active"': ''}>${(translation.creator.configuration_ipl['option:label.parking_space_floor']).format(floor)}</div>`;
                            }
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-floors').html(parkingFloorsHTML).css('grid-template-columns', `repeat(${parkingFloors}, 1fr)`);

                            let parkingSpacesHTML = '';
                            for (let i=1; i <= 38; i++) {
                                const inputId = `ipl-parking_space_${i}`;

                                const parkingOwner = HousingCreator.BuildingParking["1"][String(i)];
                                const isBlocked = (
                                    (!HousingCreator.ModifyingIdentifier && parkingOwner) ||
                                    (HousingCreator.ModifyingIdentifier && parkingOwner && parkingOwner !== HousingCreator.ModifyingIdentifier)
                                );

                                parkingSpacesHTML += `
                                    <div class="checkbox-wrapper-46 ${isBlocked ? 'not-allowed' : ''}">
                                        <input
                                            type="checkbox"
                                            id="${inputId}"
                                            class="inp-cbx ${isBlocked ? 'not-allowed' : ''}"
                                            data-toggle="ipl-parking_space"
                                            data-floor="${1}"
                                            data-parking-space="${i}"
                                            ${HousingCreator.ModifyingIdentifier ? (parkingOwner === HousingCreator.ModifyingIdentifier ? 'checked' : '') : ''}
                                        >
                                        <label for="${inputId}" class="cbx">
                                            <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                                            <label for="${inputId}" class="input-name">#${i}</label>
                                        </label>
                                    </div>
                                `
                            }
                            
                            HousingCreator.ApartmentParkingSpots = {}
                            if (HousingCreator.ModifyingIdentifier) {
                                for (const [floor, floorData] of Object.entries(HousingCreator.BuildingParking)) {
                                    for (const [spot, apartment] of Object.entries(floorData)) {
                                        if (String(apartment) === String(HousingCreator.ModifyingIdentifier)) {
                                            if (!HousingCreator.ApartmentParkingSpots[String(floor)]) {
                                                HousingCreator.ApartmentParkingSpots[String(floor)] = []
                                            }
                                            HousingCreator.ApartmentParkingSpots[String(floor)].push(String(spot))
                                        }
                                    }
                                }
                            }
                            
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space').show();
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-spaces').html(parkingSpacesHTML);
                        } else {
                            HousingCreator.BuildingParkingId = null;
                            HousingCreator.BuildingParking = null;
                            HousingCreator.ApartmentParkingSpots = null;
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space').hide();
                            $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-spaces').empty();
                        }
                    });
                }
                
                isApartment = true;
                buildingClasses.addClass('not-allowed');
                $('input[data-toggle="ipl-delivery_outside"]').prop('checked', false);
                $('input[data-toggle="ipl-furniture_environment_outside"]').prop('checked', false);
                $('input[data-toggle="ipl-__garage"]').prop('checked', false);
                $('input[data-toggle="ipl-__parking"]').prop('checked', false);
            } else {
                buildingClasses.removeClass('not-allowed');
                HousingCreator.BuildingParking = null;
                HousingCreator.BuildingParkingId = null;
            }
        }

    } else if ($("#ipl-motel").is(":checked")) {
        buildingClasses.removeClass('not-allowed');
        if (motel.id != '0') {
            isMotel = true;
            motelClasses.addClass('not-allowed');
            $('input[data-toggle="ipl-delivery_outside"]').prop('checked', false);
            $('input[data-toggle="ipl-furniture_environment_outside"]').prop('checked', false);
            $('input[data-toggle="ipl-__garage"]').prop('checked', false);
            $('input[data-toggle="ipl-__parking"]').prop('checked', false);
        } else {
            motelClasses.removeClass('not-allowed');
        }

    } else {
        if (!$("#ipl-motel").is(":checked")) {
            buildingClasses.removeClass('not-allowed');
        }
        if (!$("#ipl-building").is(":checked")) {
            motelClasses.removeClass('not-allowed');
            HousingCreator.BuildingParking = null;
            HousingCreator.BuildingParkingId = null;
        }
    }
    
    if (!isApartment) {
        HousingCreator.BuildingParkingId = null;
        HousingCreator.BuildingParking = null;
        HousingCreator.ApartmentParkingSpots = null;
        $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space').hide();
        $('.housing_creator div[data-type="configuration-ipl"]>div>.side-boxes>.box>.options .ipl-parking_space > .parking-spaces').empty();
    }

    let inputs = $(`
        input[name='ipl-name'], 
        input[name='ipl-address'], 
        input[name='ipl-region'], 
        input[name='ipl-house_name'], 
        input[name='ipl-yard_zone'], 
        input[name='ipl-enter_point'], 
        input[name='ipl-exit_point']
    `);

    if (isApartment) {
        inputs = $(`
            input[name='ipl-name'], 
            input[name='ipl-address'], 
            input[name='ipl-region'], 
            input[name='ipl-house_name']
        `);
    }

    if (isMotel) {
        inputs = $(`
            input[name='ipl-name'], 
            input[name='ipl-address'], 
            input[name='ipl-region'], 
            input[name='ipl-house_name'], 
            input[name='ipl-enter_point'], 
            input[name='ipl-exit_point']
        `);
    }

    let values = inputs.map(function () {
        return $(this).val().trim();
    }).get();

    if ($("#ipl-building").is(":checked")) {
        if (building.id == '0') {
            values.push("");
        }
    }

    if ($("#ipl-motel").is(":checked")) {
        if (motel.id == '0') {
            values.push("");
        }
    }

    let themeName = $('.housing_creator div[data-type="configuration-ipl"] .ipl-theme select').select2('data')[0]
    if (themeName.id && themeName.id == '0') {
        values.push("");
    }

    if (!isApartment && !isMotel) {
        if ($("#ipl-__garage").is(":checked") || $("#ipl-__parking").is(":checked")) {
            values.push($("input[name='ipl-garage_point']").val().trim());
        }
    }

    if ($("#ipl-purchase_price").is(":checked")) {
        values.push($("input[name='ipl-purchase_price']").val().trim());
    }
    
    if ($("#ipl-rent_price").is(":checked")) {
        values.push($("input[name='ipl-rent_price']").val().trim());
    }
    
    if ($("#ipl-keys_limit").is(":checked")) {
        values.push($("input[name='ipl-keys_limit_count']").val().trim());
    }
    
    if ($("#ipl-permissions_limit").is(":checked")) {
        values.push($("input[name='ipl-permissions_limit_count']").val().trim());
    }

    const hasEmpty = values.includes("") || values.includes(undefined);

    if (hasEmpty) {
        $('.housing_creator div[data-type="configuration-ipl"] .text > div > .save').removeClass("allowed");
    } else {
        $('.housing_creator div[data-type="configuration-ipl"] .text > div > .save').addClass("allowed");
    }
}
$(`
    .housing_creator div[data-type="configuration-ipl"] .mt-2 > input,
    input#ipl-building,
    input#ipl-motel,
    input#ipl-__garage,
    input#ipl-__parking,
    input#ipl-delivery_inside,
    input#ipl-delivery_outside,
    input#ipl-furniture_environment_outside,
    input#ipl-purchase_price,
    input#ipl-rent_price,
    input#ipl-keys_limit,
    input#ipl-permissions_limit
`).on("input change", checkIplInputs);
$('.housing_creator div[data-type="configuration-ipl"]').on('select2:select', 'select', checkIplInputs);


// ███╗   ██╗███████╗██╗    ██╗    ███╗   ███╗██╗      ██████╗ 
// ████╗  ██║██╔════╝██║    ██║    ████╗ ████║██║     ██╔═══██╗
// ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██╔████╔██║██║     ██║   ██║
// ██║╚██╗██║██╔══╝  ██║███╗██║    ██║╚██╔╝██║██║     ██║   ██║
// ██║ ╚████║███████╗╚███╔███╔╝    ██║ ╚═╝ ██║███████╗╚██████╔╝
// ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚═╝     ╚═╝╚══════╝ ╚═════╝ 
$(document).on('click', '.housing_creator div[data-type="configuration-mlo"] > div > .side-boxes > .box > .options .inp-cbx', function(e) {
    let toggle = $(this).data('toggle');
    let isChecked = $(this).prop('checked');

    if ($(this).hasClass('not-allowed')) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $(this).prop('checked', isChecked);
        return false;
    };

    if (toggle == "mlo-delivery_inside") {
        $('.inp-cbx[data-toggle="mlo-delivery_outside"]').prop('checked', false);
        $('input[name="mlo-delivery_coordinates"]').attr('value', '');
        
    } else if (toggle == "mlo-delivery_outside") {
        $('.inp-cbx[data-toggle="mlo-delivery_inside"]').prop('checked', false);
        $('input[name="mlo-delivery_coordinates"]').attr('value', '');
        
    } else if (toggle == "mlo-motel") {
        $('.inp-cbx[data-toggle="mlo-building"]').prop('checked', false);
        $('.housing_creator div[data-type="configuration-mlo"] .mlo-building > .mt-2 > select').prop('disabled', true);
        $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel > .mt-2 > select').prop('disabled', !isChecked);
        
    } else if (toggle == "mlo-storage") {
        $('.housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-slots-value"]').prop('disabled', !isChecked);
        $('.housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-weight-value"]').prop('disabled', !isChecked);

    } else if (toggle == "mlo-__garage") {
        $('.inp-cbx[data-toggle="mlo-__parking"]').prop('checked', false);
        $('input[name="mlo-garage_point"]').attr('value', '');
        
    } else if (toggle == "mlo-__parking") {
        $('.inp-cbx[data-toggle="mlo-__garage"]').prop('checked', false);
        $('input[name="mlo-garage_point"]').attr('value', '');

    } else if (toggle == "mlo-keys_limit") {
        $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-keys_limit_count"]').prop('disabled', !isChecked);

    } else if (toggle == "mlo-permissions_limit") {
        $('.housing_creator div[data-type="configuration-mlo"] input[name="mlo-permissions_limit_count"]').prop('disabled', !isChecked);
        
    }
    
    $(`.housing_creator div[data-type="configuration-mlo"] > div > .side-boxes > .box > .options input[name="${toggle}"]`).prop('disabled', !isChecked);
});

$(document).on('click', '.housing_creator div[data-type="configuration-mlo"]>div>.side-boxes>.box > .options .mt-2 > .button, .housing_creator div[data-type="configuration-mlo"]>div>.side-boxes>.box>.options .mlo-doors .button', function(e) {
    if ($(this).hasClass('not-allowed')) return;

    let buttonAction = $(this).data('button-action');
    if (!buttonAction) return;

    let jsonData = {
        type: 'mlo',
        action: buttonAction.replace(/^mlo-?/, "")
    }

    if (buttonAction == "mlo-delivery_coordinates") {
        jsonData.isInside = $('.inp-cbx[data-toggle="mlo-delivery_inside"]').prop('checked');
        jsonData.isOutside = $('.inp-cbx[data-toggle="mlo-delivery_outside"]').prop('checked');        
        if (!jsonData.isInside && !jsonData.isOutside) return;
        
    } else if (buttonAction == "mlo-remove_door") {
        jsonData.doorId = $(this).data('door-id');
        if (!jsonData.doorId) return;
        
    } else if (buttonAction == "mlo-garage_point") {
        jsonData.isGarage = $('.inp-cbx[data-toggle="mlo-__garage"]').prop('checked');
        jsonData.isParking = $('.inp-cbx[data-toggle="mlo-__parking"]').prop('checked');
        if (!jsonData.isGarage && !jsonData.isParking) return;

    } else if (buttonAction == "mlo-wardrobe_point") {
        let isWardrobeActive = $('.inp-cbx[data-toggle="mlo-wardrobe"]').prop('checked');
        if (!isWardrobeActive) return;

    } else if (buttonAction == "mlo-storage_point") {
        let isStorageActive = $('.inp-cbx[data-toggle="mlo-storage"]').prop('checked');
        if (!isStorageActive) return;

    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-mlo"] .text > div > .save.allowed', function(e) {
    let jsonData = {
        type: 'mlo',
        action: 'save'
    }
    
    if (HousingCreator.IsModifyingExisting) {
        jsonData.isModifying = HousingCreator.ModifyingIdentifier;
    }

    let isMotel = $('.inp-cbx[data-toggle="mlo-motel"]').prop("checked")
    if (isMotel) {
        let motel = $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel select').select2('data')[0]
        if (motel != "0") {
            jsonData.motel = motel.id;
        }
    }
    
    jsonData.houseName = $('input[name="mlo-house_name"]').val();
    jsonData.houseDescription = $('textarea[name="mlo-house_description"]').val();
    
    jsonData.isDeliveryInside = $('.inp-cbx[data-toggle="mlo-delivery_inside"]').prop('checked');
    jsonData.isDeliveryOutside = $('.inp-cbx[data-toggle="mlo-delivery_outside"]').prop('checked');
    
    jsonData.allowFurnitureOutside = $('.inp-cbx[data-toggle="mlo-furniture_environment_outside"]').prop('checked');
    jsonData.allowFurnitureInside = $('.inp-cbx[data-toggle="mlo-furniture_environment_inside"]').prop('checked');
    
    jsonData.isGarage = $('.inp-cbx[data-toggle="mlo-__garage"]').prop('checked');
    jsonData.isParking = $('.inp-cbx[data-toggle="mlo-__parking"]').prop('checked');
    jsonData.isWardrobe = $('.inp-cbx[data-toggle="mlo-wardrobe"]').prop('checked');
    jsonData.isStorage = $('.inp-cbx[data-toggle="mlo-storage"]').prop('checked');
    jsonData.storageSlots = $('.housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-slots-value"]').val();
    jsonData.storageWeight = $('.housing_creator div[data-type="configuration-mlo"] .mlo-storage .metadata-elements > input[name="metadata-weight-value"]').val();
    
    jsonData.isPurchase = $('.inp-cbx[data-toggle="mlo-purchase_price"]').prop('checked');
    jsonData.purchasePrice = getRawValue('input[name="mlo-purchase_price"]');
    
    jsonData.isRent = $('.inp-cbx[data-toggle="mlo-rent_price"]').prop('checked');
    jsonData.rentPrice = getRawValue('input[name="mlo-rent_price"]');
    
    jsonData.isKeysLimit = $('.inp-cbx[data-toggle="mlo-keys_limit"]').prop('checked');
    jsonData.keysLimit = $('input[name="mlo-keys_limit_count"]').val();
    
    jsonData.isPermissionsLimit = $('.inp-cbx[data-toggle="mlo-permissions_limit"]').prop('checked');
    jsonData.permissionsLimit = $('input[name="mlo-permissions_limit_count"]').val();

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-mlo"] .text > div > .delete', function(e) {
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'mlo',
        action: 'delete',
        id: HousingCreator.ModifyingIdentifier
    }));
    updateSection('.housing_creator', 'all-properties');
})

function checkMloInputs() {
    let motel = $('.housing_creator div[data-type="configuration-mlo"] .mlo-motel select').select2('data')[0]
    let motelClasses = $(`
        input[name="mlo-yard_zone"],
        .button[data-button-action="mlo-yard_zone"],

        label[for="mlo-delivery_outside"],
        input[data-toggle="mlo-delivery_outside"],
        
        label[for="mlo-furniture_environment_outside"],
        input[data-toggle="mlo-furniture_environment_outside"],

        label[for="mlo-__garage"],
        input[data-toggle="mlo-__garage"],
        label[for="mlo-__parking"],
        input[data-toggle="mlo-__parking"],
        input[name="mlo-garage_point"],
        .button[data-button-action="mlo-garage_point"]
    `);

    let isMotel = false;
    if ($("#mlo-motel").is(":checked")) {
        if (motel.id != '0') {
            isMotel = true;
            motelClasses.addClass('not-allowed');
            $('input[data-toggle="mlo-delivery_outside"]').prop('checked', false);
            $('input[data-toggle="mlo-furniture_environment_outside"]').prop('checked', false);
            $('input[data-toggle="mlo-__garage"]').prop('checked', false);
            $('input[data-toggle="mlo-__parking"]').prop('checked', false);
        } else {
            motelClasses.removeClass('not-allowed');
        }
    } else {
        motelClasses.removeClass('not-allowed');
    }

    let inputs = $(`
        input[name='mlo-name'], 
        input[name='mlo-address'], 
        input[name='mlo-region'], 
        input[name='mlo-house_name'], 
        input[name='mlo-yard_zone'], 
        input[name='mlo-interior_zone'], 
        input[name='mlo-menu_point']
    `);
    
    if (isMotel) {
        inputs = $(`
            input[name='mlo-name'], 
            input[name='mlo-address'], 
            input[name='mlo-region'], 
            input[name='mlo-house_name'], 
            input[name='mlo-interior_zone'], 
            input[name='mlo-menu_point']
        `);
    }
    
    let values = inputs.map(function () {
        return $(this).val().trim();
    }).get();

    if ($("#mlo-motel").is(":checked")) {
        if (motel.id == '0') {
            values.push("");
        }
    }

    if (!isMotel) {
        if ($("#mlo-__garage").is(":checked") || $("#mlo-__parking").is(":checked")) {
            values.push($("input[name='mlo-garage_point']").val().trim());
        }
    }

    if ($("#mlo-purchase_price").is(":checked")) {
        values.push($("input[name='mlo-purchase_price']").val().trim());
    }
    
    if ($("#mlo-rent_price").is(":checked")) {
        values.push($("input[name='mlo-rent_price']").val().trim());
    }

    if ($("#mlo-keys_limit").is(":checked")) {
        values.push($("input[name='mlo-keys_limit_count']").val().trim());
    }
    
    if ($("#mlo-permissions_limit").is(":checked")) {
        values.push($("input[name='mlo-permissions_limit_count']").val().trim());
    }

    const hasEmpty = values.includes("") || values.includes(undefined);

    if (hasEmpty) {
        $('.housing_creator div[data-type="configuration-mlo"] .text > div > .save').removeClass("allowed");
    } else {
        $('.housing_creator div[data-type="configuration-mlo"] .text > div > .save').addClass("allowed");
    }
}
$(`
    .housing_creator div[data-type="configuration-mlo"] .mt-2 > input,
    input#mlo-motel,
    input#mlo-__garage,
    input#mlo-__parking,
    input#mlo-delivery_inside,
    input#mlo-delivery_outside,
    input#mlo-purchase_price,
    input#mlo-rent_price,
    input#mlo-keys_limit,
    input#mlo-permissions_limit
`).on("input change", checkMloInputs);
$('.housing_creator div[data-type="configuration-mlo"]').on('select2:select', 'select', checkMloInputs);



// ███╗   ██╗███████╗██╗    ██╗    ██████╗ ██╗   ██╗██╗██╗     ██████╗ ██╗███╗   ██╗ ██████╗ 
// ████╗  ██║██╔════╝██║    ██║    ██╔══██╗██║   ██║██║██║     ██╔══██╗██║████╗  ██║██╔════╝ 
// ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██████╔╝██║   ██║██║██║     ██║  ██║██║██╔██╗ ██║██║  ███╗
// ██║╚██╗██║██╔══╝  ██║███╗██║    ██╔══██╗██║   ██║██║██║     ██║  ██║██║██║╚██╗██║██║   ██║
// ██║ ╚████║███████╗╚███╔███╔╝    ██████╔╝╚██████╔╝██║███████╗██████╔╝██║██║ ╚████║╚██████╔╝
// ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
$(document).on('click', '.housing_creator div[data-type="configuration-building"] > div > .side-boxes > .box > .options > div .inp-cbx', function(e) {
    let toggle = $(this).data('toggle');
    let isChecked = $(this).prop('checked');

    if ($(this).hasClass('not-allowed')) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $(this).prop('checked', isChecked);
        return false;
    };

    if (toggle == "building-__underground_parking") {
        $('input[name="building-underground_parking_floors"]').prop('disabled', !isChecked);
    }

    $(`.housing_creator div[data-type="configuration-building"] > div > .side-boxes > .box > .options input[name="${toggle}"]`).prop('disabled', !isChecked);
});

$(document).on('click', '.housing_creator div[data-type="configuration-building"]>div>.side-boxes>.box > .options .mt-2 > .button', function(e) {
    if ($(this).hasClass('not-allowed')) return;

    let buttonAction = $(this).data('button-action');
    if (!buttonAction) return;
    
    let jsonData = {
        type: 'building',
        action: buttonAction.replace(/^building-?/, "")
    }

    if (buttonAction == 'building-enter_garage_point' && !$('.inp-cbx[data-toggle="building-__underground_parking"]').prop('checked')) {
        return
    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-building"] .text > div > .save.allowed', function(e) {
    let jsonData = {
        type: 'building',
        action: 'save'
    }
    
    if (HousingCreator.IsModifyingExisting) {
        jsonData.isModifying = HousingCreator.ModifyingIdentifier;
    }
    
    jsonData.buildingName = $('input[name="building-name"]').val();
    
    jsonData.apartmentParking = $('.inp-cbx[data-toggle="building-__underground_parking"]').prop('checked');
    jsonData.parkingFloors = $('input[name="building-underground_parking_floors"]').val();
    
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-building"] .text > div > .delete', function(e) {
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'building',
        action: 'delete',
        id: HousingCreator.ModifyingIdentifier
    }));
    updateSection('.housing_creator', 'all-properties');
})

function checkBuildingInputs() {
    const inputs = $(`
        input[name='building-address'], 
        input[name='building-region'], 
        input[name='building-name'], 
        input[name='building-yard_zone'], 
        input[name='building-enter_point'], 
        input[name='building-exit_point']
    `);

    let values = inputs.map(function () {
        return $(this).val().trim();
    }).get();

    if ($("#building-__garage").is(":checked")) {
        values.push($("input[name='building-garage_point']").val().trim());
    }
    if ($("#building-__underground_parking").is(":checked")) {
        values.push($("input[name='building-underground_parking_floors']").val().trim());
        values.push($("input[name='building-enter_garage_point']").val().trim());
    }

    const hasEmpty = values.includes("") || values.includes(undefined);

    if (hasEmpty) {
        $('.housing_creator div[data-type="configuration-building"] .text > div > .save').removeClass("allowed");
    } else {
        $('.housing_creator div[data-type="configuration-building"] .text > div > .save').addClass("allowed");
    }
}
$(`
    .housing_creator div[data-type="configuration-building"] .mt-2 > input,
    input#building-__garage,
    input#building-__underground_parking
`).on("input change", checkBuildingInputs);
$('.housing_creator div[data-type="configuration-building"]').on('select2:select', 'select', checkBuildingInputs);



// ███╗   ██╗███████╗██╗    ██╗    ███╗   ███╗ ██████╗ ████████╗███████╗██╗     
// ████╗  ██║██╔════╝██║    ██║    ████╗ ████║██╔═══██╗╚══██╔══╝██╔════╝██║     
// ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██╔████╔██║██║   ██║   ██║   █████╗  ██║     
// ██║╚██╗██║██╔══╝  ██║███╗██║    ██║╚██╔╝██║██║   ██║   ██║   ██╔══╝  ██║     
// ██║ ╚████║███████╗╚███╔███╔╝    ██║ ╚═╝ ██║╚██████╔╝   ██║   ███████╗███████╗
// ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚══════╝╚══════╝
$(document).on('click', '.housing_creator div[data-type="configuration-motel"] > div > .side-boxes > .box > .options > div .inp-cbx', function(e) {
    let toggle = $(this).data('toggle');
    let isChecked = $(this).prop('checked');

    if ($(this).hasClass('not-allowed')) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $(this).prop('checked', isChecked);
        return false;
    };
    
    $(`.housing_creator div[data-type="configuration-motel"] > div > .side-boxes > .box > .options input[name="${toggle}"]`).prop('disabled', !isChecked);
});

$(document).on('click', '.housing_creator div[data-type="configuration-motel"]>div>.side-boxes>.box > .options .mt-2 > .button', function(e) {
    if ($(this).hasClass('not-allowed')) return;

    let buttonAction = $(this).data('button-action');
    if (!buttonAction) return;
    
    let jsonData = {
        type: 'motel',
        action: buttonAction.replace(/^motel-?/, "")
    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-motel"] .text > div > .save.allowed', function(e) {
    let jsonData = {
        type: 'motel',
        action: 'save'
    }
    
    if (HousingCreator.IsModifyingExisting) {
        jsonData.isModifying = HousingCreator.ModifyingIdentifier;
    }

    jsonData.motelName = $('input[name="motel-name"]').val();
    jsonData.isGarage = $('.inp-cbx[data-toggle="ipl-__garage"]').prop('checked');
    
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
})

$(document).on('click', '.housing_creator div[data-type="configuration-motel"] .text > div > .delete', function(e) {
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'motel',
        action: 'delete',
        id: HousingCreator.ModifyingIdentifier
    }));
    updateSection('.housing_creator', 'all-properties');
})

function checkMotelInputs() {
    const inputs = $(`
        input[name='motel-address'], 
        input[name='motel-region'], 
        input[name='motel-name'], 
        input[name='motel-yard_zone']
    `);

    let values = inputs.map(function () {
        return $(this).val().trim();
    }).get();

    const hasEmpty = values.includes("") || values.includes(undefined);

    if (hasEmpty) {
        $('.housing_creator div[data-type="configuration-motel"] .text > div > .save').removeClass("allowed");
    } else {
        $('.housing_creator div[data-type="configuration-motel"] .text > div > .save').addClass("allowed");
    }
}
$(`
    .housing_creator div[data-type="configuration-motel"] .mt-2 > input
`).on("input change", checkMotelInputs);
$('.housing_creator div[data-type="configuration-motel"]').on('select2:select', 'select', checkMotelInputs);



// ███╗   ██╗███████╗██╗    ██╗    ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗████████╗██╗   ██╗██████╗ ███████╗
// ████╗  ██║██╔════╝██║    ██║    ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚══██╔══╝██║   ██║██╔══██╗██╔════╝
// ██╔██╗ ██║█████╗  ██║ █╗ ██║    █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝█████╗  
// ██║╚██╗██║██╔══╝  ██║███╗██║    ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗██╔══╝  
// ██║ ╚████║███████╗╚███╔███╔╝    ██║     ╚██████╔╝██║  ██║██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║███████╗
// ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
$(document).on('click', '.housing_creator div[data-type="configuration-furniture"] .mt-4 div[data-tag]', function(e) {
    if ($(this).hasClass('active')) {
        $('.housing_creator div[data-type="configuration-furniture"] .mt-4 div[data-tag]').removeClass('active');
    } else {
        $('.housing_creator div[data-type="configuration-furniture"] .mt-4 div[data-tag]').removeClass('active');
        $(this).addClass('active');
    }
})

$(document).on('click', '.housing_creator div[data-type="configuration-furniture"] > div > .side-boxes > .box > .options > div .inp-cbx', function(e) {
    let toggle = $(this).data('toggle');
    let isChecked = $(this).prop('checked');

    if (toggle == "furniture-delivery_small") {
        $('.inp-cbx[data-toggle="furniture-delivery_medium"]').prop('checked', false);
        $('.inp-cbx[data-toggle="furniture-delivery_big"]').prop('checked', false);
        
    } else if (toggle == "furniture-delivery_medium") {
        $('.inp-cbx[data-toggle="furniture-delivery_small"]').prop('checked', false);
        $('.inp-cbx[data-toggle="furniture-delivery_big"]').prop('checked', false);
        
    } else if (toggle == "furniture-delivery_big") {
        $('.inp-cbx[data-toggle="furniture-delivery_small"]').prop('checked', false);
        $('.inp-cbx[data-toggle="furniture-delivery_medium"]').prop('checked', false);

    }
    
    $(`.housing_creator div[data-type="configuration-furniture"] > div > .side-boxes > .box > .options input[name="${toggle}"]`).prop('disabled', !isChecked);
});

$(document).on('click', '.housing_creator div[data-type="configuration-furniture"] .text > div > .save', function(e) {
    let jsonData = {
        type: 'furniture',
        action: 'save',
        model: HousingCreator.ModifyingIdentifier,
    }
    
    jsonData.label = $('input[name="furniture-label"]').val();
    jsonData.price = $('input[name="furniture-price"]').val();

    let selectedTag = "";
    if ($('.housing_creator div[data-type="configuration-furniture"]>div>.side-boxes>.box > .options .mt-4 > div[data-tag].active')) {
        selectedTag = $('.housing_creator div[data-type="configuration-furniture"]>div>.side-boxes>.box > .options .mt-4 > div[data-tag].active').data('tag');
    }
    jsonData.tag = selectedTag;

    jsonData.isFurnitureInside = $('.inp-cbx[data-toggle="furniture-inside"]').prop('checked');
    jsonData.isFurnitureOutside = $('.inp-cbx[data-toggle="furniture-outside"]').prop('checked');
    
    jsonData.isSmallDelivery = $('.inp-cbx[data-toggle="furniture-delivery_small"]').prop('checked');
    jsonData.isMediumDelivery = $('.inp-cbx[data-toggle="furniture-delivery_medium"]').prop('checked');
    jsonData.isBigDelivery = $('.inp-cbx[data-toggle="furniture-delivery_big"]').prop('checked');

    jsonData.interactableName = $('.housing_creator div[data-type="configuration-furniture"] select[name="furniture-interactable-name"]').select2('data')[0].id;
    if (jsonData.interactableName == 0 || jsonData.interactableName == "0") jsonData.interactableName = null;

    if (jsonData.interactableName && config.configuratorFurnitureMetadata[jsonData.interactableName]) {
        jsonData.metadata = {};
        config.configuratorFurnitureMetadata[jsonData.interactableName].forEach(element => {
            jsonData.metadata[element.key] = $(`.housing_creator div[data-type="configuration-furniture"] input[name="metadata-${element.key}-value"]`).val();
            if (element.key == 'slots' || element.key == 'weight') {
                jsonData.metadata[element.key] = Number(jsonData.metadata[element.key])
            }
        });
    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify(jsonData));
    setTimeout(() => {
        updateSection('.housing_creator', 'all-furniture');
    }, 500);
})

$(document).on('click', '.housing_creator div[data-type="configuration-furniture"] .text > div > .delete', function(e) {
    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'furniture',
        action: 'delete',
        model: HousingCreator.ModifyingIdentifier
    }));
    setTimeout(() => {
        updateSection('.housing_creator', 'all-furniture');
    }, 500);
})



$(document).on('click', '.housing_creator div[data-type="all-furniture"] > div > .side-boxes > .box .text .title.button-create', function(e) {
    $('.housing_creator>div>.menu>#register-new-furniture').fadeIn(120);
})

$(document).on('click', '.housing_creator>div>.menu>#register-new-furniture>div>.buttons>div', function(e) {
    let props = [];

    for (const [k, v] of Object.entries(propsList.value)) {
        props.push(v.value)
    }

    $.post(`https://${GetParentResourceName()}/creator:actionButton`, JSON.stringify({
        type: 'furniture',
        action: 'register',
        props: props
    }));

    propsList.removeAllTags()
})

$(document).on('click', '.housing_creator>div>.menu>#register-new-furniture', function(e) {
    if (!$(e.target).closest('#register-new-furniture > div').length) {
        $('.housing_creator>div>.menu>#register-new-furniture').fadeOut(120);
        propsList.removeAllTags()
    }
})

$(document).on('keypress', '.housing_creator div[data-type="all-properties"] > div > .side-boxes > .box .text input', function (e) {
    if (e.key === "Enter") {
        e.preventDefault();
        
        const searchTerm = $(this).val().trim().toLowerCase();
        HousingCreator.Pagination.CurrentPage = 1;
        HousingCreator.Pagination.SearchTerm = searchTerm;

        if (searchTerm === "") {
            HousingCreator.Pagination.ArrayFiltered = [];
            HousingCreator.RenderPagination('all-properties');
            return;
        }

        HousingCreator.Pagination.ArrayFiltered = HousingCreator.Pagination.Array.filter(item => {
            return item.name.toLowerCase().includes(searchTerm) || item.address.toLowerCase().includes(searchTerm) || (item.owner && item.owner.toLowerCase().includes(searchTerm)) || (item.renter && item.renter.toLowerCase().includes(searchTerm));
        });

        HousingCreator.RenderPagination('all-properties');
    }
});

$('.housing_creator .main > div[data-type="all-properties"] #prev-page').click(function() {
    if (HousingCreator.Pagination.CurrentPage > 1) {
        HousingCreator.Pagination.CurrentPage--;
        HousingCreator.RenderPagination('all-properties');
        HousingCreator.UpdatePagination('all-properties');
    }
});

$('.housing_creator .main > div[data-type="all-properties"] #next-page').click(function() {
    if (HousingCreator.Pagination.CurrentPage < Math.ceil((HousingCreator.Pagination.SearchTerm != "" ? HousingCreator.Pagination.ArrayFiltered.length : HousingCreator.Pagination.Array.length) / HousingCreator.Pagination.ItemsPerPage)) {
        HousingCreator.Pagination.CurrentPage++;
        HousingCreator.RenderPagination('all-properties');
        HousingCreator.UpdatePagination('all-properties');
    }
});

$(document).on('keypress', '.housing_creator div[data-type="all-furniture"] > div > .side-boxes > .box .text input', function (e) {
    if (e.key === "Enter") {
        e.preventDefault();
        
        const searchTerm = $(this).val().trim().toLowerCase();
        HousingCreator.Pagination.CurrentPage = 1;
        HousingCreator.Pagination.SearchTerm = searchTerm;

        if (searchTerm === "") {
            HousingCreator.Pagination.ArrayFiltered = [];
            HousingCreator.RenderPagination('all-furniture');
            return;
        }

        HousingCreator.Pagination.ArrayFiltered = HousingCreator.Pagination.Array.filter(item => {
            return item.label.toLowerCase().includes(searchTerm) || item.model.toLowerCase().includes(searchTerm);
        });

        HousingCreator.RenderPagination('all-furniture');
    }
});

$('.housing_creator .main > div[data-type="all-furniture"] #prev-page').click(function() {
    if (HousingCreator.Pagination.CurrentPage > 1) {
        HousingCreator.Pagination.CurrentPage--;
        HousingCreator.RenderPagination('all-furniture');
        HousingCreator.UpdatePagination('all-furniture');
    }
});

$('.housing_creator .main > div[data-type="all-furniture"] #next-page').click(function() {
    if (HousingCreator.Pagination.CurrentPage < Math.ceil((HousingCreator.Pagination.SearchTerm != "" ? HousingCreator.Pagination.ArrayFiltered.length : HousingCreator.Pagination.Array.length) / HousingCreator.Pagination.ItemsPerPage)) {
        HousingCreator.Pagination.CurrentPage++;
        HousingCreator.RenderPagination('all-furniture');
        HousingCreator.UpdatePagination('all-furniture');
    }
});

$('.housing_creator').on('select2:select', 'select[name="furniture-interactable-name"]', function (e) {
    let interableName = $(this).select2('data')[0]

    $('.housing_creator div[data-type="configuration-furniture"] .metadata-list').hide();
    $('.housing_creator div[data-type="configuration-furniture"] .metadata-elements').empty();
    
    
    if (interableName.id && interableName.id != '0' && config.configuratorFurnitureMetadata[interableName.id]) {
        let metadataElementsHTML = '';
     
        config.configuratorFurnitureMetadata[interableName.id].forEach(element => {
            metadataElementsHTML += `
                <input name="metadata-${element.key}-key" type="text" value="${element.key}" disabled>
                <input name="metadata-${element.key}-value" type="${element.allowedValue || "text"}" value="${element.defaultValue}">
            `
        });

        $('.housing_creator div[data-type="configuration-furniture"] .metadata-list').show();
        $('.housing_creator div[data-type="configuration-furniture"] .metadata-elements').html(metadataElementsHTML);
    }
});

function initGallery(container, buttonsContainer) {
    if (container.hasClass('gallery-initialized')) return;

    let currentTheme = null;
    const gallery = container.find(".gallery");
    const images = container.find(".gallery img");
    const prevBtn = container.find(".prev");
    const nextBtn = container.find(".next");
    const thumbnails = container.find(".thumbnail");

    let currentIndex = 0;

    function updateGallery(index) {
        if (container.hasClass('theme_selection_gallery')) {
            currentTheme = images.eq(index).data("theme");
        }
        gallery.css("transform", `translateX(-${index * 100}%)`);
        thumbnails.removeClass("active");
        thumbnails.eq(index).addClass("active");
    }

    nextBtn.on("click", function () {
        currentIndex = (currentIndex + 1) % images.length;
        updateGallery(currentIndex);
    });

    prevBtn.on("click", function () {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
        updateGallery(currentIndex);
    });

    thumbnails.each(function (index) {
        $(this).on("click", function () {
            currentIndex = index;
            updateGallery(currentIndex);
        });
    });

    if (buttonsContainer && container.hasClass('theme_selection_gallery')) {
        const selectBtn = buttonsContainer.find('#select-ipl-theme');

        selectBtn.on('click', () => {
            Property.SelectedTheme = currentTheme;
        });
    }

    if (container.hasClass('theme_selection_gallery')) {
        currentTheme = images.eq(currentIndex).data("theme");
    }

    container.addClass('gallery-initialized');
}