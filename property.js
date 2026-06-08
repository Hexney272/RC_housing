const Property = {
    ManageData: [],
    FurnitureList: [],
    
    SelectedTheme: null,

    HasPermission: function(perm) {
        if (!this.ManageData) return false;
        return this.ManageData.isOwner || this.ManageData.myPermissions?.[perm] === true
    },

    OpenViewOffer: function (data, isBack) {
        this.SelectedApartmentId = null;

        $('.property_offer > div').css('height', '48em');
        $(`
            .property_offer > div > .menu,
            .property_offer > div > .menu > .main > .description,
            .property_offer > div > .menu > .main > .informations,
            .property_offer > div > .menu > .main > .buttons
        `).show();

        $(`
            .property_offer .title > .house-name,
            .property_offer > div > .theme_selection,
            .property_offer > div > .menu > .main > .apartments-actions,
            .property_offer > div > .menu > .main > .apartments-list
        `).hide();

        $(`
            .property_offer > div > .theme_selection .main,
            .property_offer > div > .menu > .main > .apartments-actions,
            .property_offer > div > .menu > .main > .apartments-list
        `).empty();

        if (data.data.id) this.SelectedApartmentId = data.data.id;
        if (!isBack) this.SelectedTheme = null;

        if (data.data.name && data.data.name.length >= 1) {
            $('.property_offer .title > .house-name > span').text(data.data.name);
            $('.property_offer .title > .house-name').show();
        }
        
        $('.property_offer .title > .house-address > span').text(data.data.address);
        
        $('.property_offer .description').hide();
        if (data.data.description && data.data.description.length >= 1) {
            $('.property_offer .description > span').text(data.data.description);
            $('.property_offer .description').show();
        }
        
        $('.property_offer .informations > .house-region > span').text(data.data.region);

        $('.property_offer .informations > .house-area').hide();
        if (data.data.area) {
            $('.property_offer .informations > .house-area > span').text(`${data.data.area} ${translation.area_units[areaUnit]}`);
            $('.property_offer .informations > .house-area').show();
        }

        $('.property_offer .informations > .house-rooms').hide();
        if (data.data.rooms != undefined) {
            $('.property_offer .informations > .house-rooms > span').text(data.data.rooms);
            $('.property_offer .informations > .house-rooms').show();
        }
        
        $('.property_offer .informations > .house-garage').hide();
        $('.property_offer .informations > .house-parking-spaces').hide();
        if (data.data.parking) {
            $('.property_offer .informations > .house-parking-spaces').show();
            $('.property_offer .informations > .house-parking-spaces > span').text(data.data.parking.length);
        } else if (data.data.parkingSpaces) {
            let parkingSpaces = 0;
            if (usingVMSGarages) {
                for (const [floor, floorSpaces] of Object.entries(data.data.parkingSpaces)) {
                    for (const [spotId, propertyId] of Object.entries(floorSpaces)) {
                        if (propertyId == data.data.id) {
                            parkingSpaces += 1
                        }
                    }
                }
                $('.property_offer .informations > .house-parking-spaces').show();
                $('.property_offer .informations > .house-parking-spaces > span').text(parkingSpaces);
            }
        } else if (data.data.garage) {
            $('.property_offer .informations > .house-garage').show();
            $('.property_offer .informations > .house-garage > span').text(data.data.garage ? `✓` : `✗`);
        }

        $('.property_offer .informations > .house-purchase-price').hide();
        if (data.data.purchasePrice && data.data.purchasePrice >= 1) {
            $('.property_offer .informations > .house-purchase-price > span').text(translation.currency + formatNumber(data.data.purchasePrice, 0, 2));
            $('.property_offer .informations > .house-purchase-price').show();
        }
        
        $('.property_offer .informations > .house-rent-price').hide();
        if (data.data.rentPrice && data.data.rentPrice >= 1) {
            $('.property_offer .informations > .house-rent-price > span').text('$' + formatNumber(data.data.rentPrice, 0, 2));
            $('.property_offer .informations > .house-rent-price').show();
        }
        
        $('.property_offer .informations > .house-electricity-bill').hide();
        if (data.data.electricity && data.data.electricity.rate && data.data.electricity.rate >= 0.0) {
            $('.property_offer .informations > .house-electricity-bill > span').html(translation.currency + formatNumber(data.data.electricity.rate, 2, 2) + `<span>/${data.data.electricity.unit}</span>`);
            $('.property_offer .informations > .house-electricity-bill').show();
        }

        $('.property_offer .informations > .house-internet-bill').hide();
        if (data.data.internet && data.data.internet.flatRate && data.data.internet.flatRate >= 0.0) {
            $('.property_offer .informations > .house-internet-bill > span').html(translation.currency + formatNumber(data.data.internet.flatRate, 2, 2));
            $('.property_offer .informations > .house-internet-bill').show();
        }
        
        $('.property_offer .informations > .house-water-bill').hide();
        if (data.data.water && data.data.water.rate && data.data.water.rate >= 0.0) {
            $('.property_offer .informations > .house-water-bill > span').html(translation.currency + formatNumber(data.data.water.rate, 2, 2) + `<span>/${data.data.water.unit}</span>`);
            $('.property_offer .informations > .house-water-bill').show();
        }
        
        let buttons = 0
        if (data.data.ipl && data.data.allowChangeTheme) {
            $(".property_offer .menu > .main > .buttons > .change_theme").show();
            buttons += 1

            $('.property_offer').off('click', '.buttons .change_theme').on('click', '.buttons .change_theme', function (e) {
                Property.ThemeSelection(data.data.ipl);
            });
            
            $('.property_offer .theme_selection').off('click', '.buttons div').on('click', '.buttons div', function (e) {
                Property.OpenViewOffer(data, true);
            });
        } else {
            $(".property_offer .menu > .main > .buttons > .change_theme").hide();
        }
        
        $(".property_offer .menu > .main > .buttons > .finalize").hide();
        $(".property_offer .menu > .main > .buttons > .view").hide();
        if (data.data.type == 'shell' || data.data.type == 'ipl') {
            $(".property_offer .menu > .main > .buttons > .view").show();
            buttons += 1
        }

        if (data.data.purchasePrice != undefined || data.data.rentPrice != undefined) {
            $(".property_offer .menu > .main > .buttons > .finalize").show();
            buttons += 1
        }

        $(".property_offer .menu > .main > .buttons").css('grid-template-columns', `repeat(${buttons}, 1fr)`);


        $('.property_offer').fadeIn(120);

        $('.property_offer').off('click', '.buttons .finalize').on('click', '.buttons .finalize', function (e) {
            Property.ViewOfferContract(data);
        });
    },

    CloseViewOffer: function (data) {
        $(`.property_offer, .contract`).fadeOut(120)
        $('.marketplace').removeClass('contract-opened');
        if (!data.dontRemoveCurrentMenu) {
            currentMenu = null;
        }
    },

    ViewOfferContract: function (data) {
        if (!data.data.rentPrice && !data.data.purchasePrice) return;

        $('.contract .buttons > div[data-type="rent"]').show();
        if (!data.data.rentPrice) $('.contract .buttons > div[data-type="rent"]').hide();
        
        $('.contract .buttons > div[data-type="purchase"]').show();
        if (!data.data.purchasePrice) $('.contract .buttons > div[data-type="purchase"]').hide();
        
        if (data.data.rentPrice) {
            reloadContract('rent', data)
        } else if (data.data.purchasePrice) {
            reloadContract('purchase', data)
        }
        
        if (data.data.isByMarketplace) {
            $('.marketplace').fadeOut(150).addClass('contract-opened');
        }

        $('.contract').fadeIn(150);

        $('.contract').off('click', '.buttons > div[data-type="rent"]').on('click', '.buttons > div[data-type="rent"]', function (e) {
            reloadContract('rent', data);
        });

        $('.contract').off('click', '.buttons > div[data-type="purchase"]').on('click', '.buttons > div[data-type="purchase"]', function (e) {
            reloadContract('purchase', data);
        });
    },

    ThemeSelection: function (ipl) {
        let imagesCount = 0;
        let imagesElements = '';
        let imagesElementsDots = '';
        for (const [name, data] of Object.entries(HousingCreator.AvailableIPLS[ipl].settings.Themes)) {
            imagesCount += 1;
            imagesElements = imagesElements + `<img data-theme="${name}" src="./images/${data.image}" draggable="false">`;
            imagesElementsDots = imagesElementsDots + `<div class="thumbnail ${imagesCount == 1 ? 'active' : ''}"></div>`;
        }

        let themeSelectionHTML = `
            <div>
                <div class="gallery-container theme_selection_gallery">
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
                    <div id="back">
                        <i class="fa-solid fa-angle-left"></i>
                        <span>${translation['button.back']}</span>
                    </div>
                    <div id="select-ipl-theme">
                        <i class="fa-solid fa-check"></i>
                        <span>${translation['button.select']}</span>
                    </div>
                </div>
            </div>
        `;

        const newElement = $(themeSelectionHTML);

        $('.property_offer > div > .menu').hide();
        $('.property_offer > div > .theme_selection .main').html(newElement);
        $('.property_offer > div > .theme_selection').show();
        $('.property_offer > div').css('height', '27em');
        
        newElement.find('.gallery-container').each(function () {
            const buttons = newElement.find('.buttons')
            initGallery($(this), buttons);
        });
    },

    BuildingMenu: function (data) {
        $('.property_offer > div').css('height', '48em');

        $(`
            .property_offer > div > .menu > .main > .description,
            .property_offer > div > .menu > .main > .informations,
            .property_offer > div > .menu > .main > .buttons,
            .property_offer > div > .theme_selection
        `).hide();
        $(`
            .property_offer > div > .menu,
            .property_offer > div > .menu > .main > .apartments-actions,
            .property_offer > div > .menu > .main > .apartments-list
        `).show();
        $(`
            .property_offer > div > .theme_selection .main,
            .property_offer > div > .menu > .main > .apartments-actions,
            .property_offer > div > .menu > .main > .apartments-list
        `).empty();

        $('.property_offer > div > .menu > .main .house-name > span').text(data.data.buildingData.name);
        $('.property_offer > div > .menu > .main .house-address > span').text(data.data.buildingData.address);
        
        let apartmentsHTML = '';
        for (const [key, value] of Object.entries(data.data.apartments)) {
            apartmentsHTML += `
                <div>
                    <div class="label">${value.name}</div>
                    <div class="button" data-apartment-id="${value.id}">${translation['button.view']}</div>
                </div>
            `;
        }
        $('.property_offer > div > .menu > .main > .apartments-list').html(apartmentsHTML);

        $('.property_offer').fadeIn(120);
    },

    ApartmentMenu: function (data) {
        $('.property_offer > div').css('height', '48em');

        $(`
            .property_offer > div > .menu > .main > .apartments-list,
            .property_offer > div > .menu > .main > .description,
            .property_offer > div > .menu > .main > .informations,
            .property_offer > div > .menu > .main > .buttons,
            .property_offer > div > .theme_selection
        `).hide();
        $(`
            .property_offer > div > .menu
        `).show();
        $(`
            .property_offer > div > .theme_selection .main,
            .property_offer > div > .menu > .main > .apartments-list
        `).empty();

        $('.property_offer > div > .menu > .main .house-name > span').text(data.data.buildingData.name);
        $('.property_offer > div > .menu > .main .house-address > span').text(data.data.buildingData.address);

        // this.ReloadApartmentMenu(data);
    },

    ReloadApartmentMenu: function (data) {
        if (data.data.apartmentData) {
            let apartmentHTML = `
                ${(data.data.hasPermManage && !data.data.apartmentData.metadata.lockdown) ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="manage">
                        <div><i class="fa-solid fa-gear"></i> ${translation.building.options['manage']}</div>
                        <span></span>
                    </div>
                ` : ''}

                ${(data.data.isKeyHolder && !data.data.apartmentData.metadata.lockdown) ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="lock">
                        <div><i class="fa-solid fa-unlock-keyhole"></i> ${translation.building.options['toggle_lock']}</div>
                        <span></span>
                    </div>
                ` : ''}
            
                ${data.data.canLockdown ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="lockdown">
                        <div><i class="fa-solid fa-road-barrier"></i> ${translation.building.options['lockdown']}</div>
                        <span></span>
                    </div>
                ` : ''}
            
                ${data.data.canRemovePoliceSeal ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="remove_police_seal">
                        <div><i class="fa-solid fa-lock-open"></i> ${translation.building.options['remove_police_seal']}</div>
                        <span></span>
                    </div>
                ` : ''}
            
                ${data.data.canRaid ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="raid">
                        <div><i class="fa-solid fa-person-walking-arrow-right"></i> ${translation.building.options['raid']}</div>
                        <span></span>
                    </div>
                ` : ''}

                ${data.data.canLockAfterRaid ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="raid_lock">
                        <div><i class="fa-solid fa-door-closed"></i> ${translation.building.options['raid_lock']}</div>
                        <span></span>
                    </div>
                ` : ''}
                
                <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="doorbell">
                    <div><i class="fa-solid fa-bell"></i> ${translation.building.options['doorbell']}</div>
                    <span></span>
                </div>

                ${(data.data.canLockpick && !data.data.apartmentData.metadata.lockdown) ? `
                    <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="lockpick" style="display: ${data.data.apartmentData.metadata.locked ? 'block' : 'none'};">
                        <div><i class="fa-solid fa-unlock-keyhole"></i> ${translation.building.options['lockpick']}</div>
                        <span></span>
                    </div>
                ` : ''}

                <div data-apartment-id="${data.data.apartmentData.id}" data-apartment-action="enter" style="display: ${data.data.apartmentData.metadata.locked ? 'none' : 'block'};">
                    <div><i class="fa-solid fa-door-open"></i> ${translation.building.options['enter']}</div>
                    <span></span>
                </div>
            `;

            $('.property_offer > div > .menu > .main > .apartments-actions').html(apartmentHTML);
        }
    },
    
    LoadManageMenu: function () {
        let firstMenu = 'my-house';
        
        $('.housing_manage .menu ul.side-bar').html(`
            <span>${translation.manage.side_menu['section:general']} <div class="separator"></div></span>
            <li class="element" data-href="my-house">
                <i class="fa-solid fa-house"></i>
                <p class="label">${translation.manage.side_menu['option:my_house']}</p>
            </li>
            
            <span>${translation.manage.side_menu['section:furniture']} <div class="separator"></div></span>
            ${this.HasPermission('furniture') ? `
                ${requirePurchaseFurniture ? `
                    <li class="element" data-href="order-furniture">
                        <i class="fa-solid fa-truck-ramp-box"></i>
                        <p class="label">${translation.manage.side_menu['option:order_furniture']}</p>
                    </li>
                ` : ''}
                <li class="element" data-href="furniture">
                    <i class="fa-solid fa-chair"></i>
                    <p class="label">${translation.manage.side_menu['option:furniture']}</p>
                </li>
            ` : ''}
            ${this.ManageData && this.ManageData.type == 'mlo' ? `
                <li class="element" data-href="check-cameras">
                    <i class="fa-solid fa-video"></i>
                    <p class="label">${translation.manage.side_menu['option:check_cameras']}</p>
                </li>
            ` : `
                <li class="element" data-href="check-cameras-inside">
                    <i class="fa-solid fa-video"></i>
                    <p class="label">${translation.manage.side_menu['option:check_cameras_inside']}</p>
                </li>
                ${this.ManageData && !this.ManageData.isObject ? `
                    <li class="element" data-href="check-cameras-outside">
                        <i class="fa-solid fa-video"></i>
                        <p class="label">${translation.manage.side_menu['option:check_cameras_outside']}</p>
                    </li>
                ` : ''}
            `}

            ${(this.ManageData && (this.ManageData.isRenter || this.HasPermission('billPayments') || this.HasPermission('keysManage') || this.HasPermission('upgradesManage') || (this.HasPermission('furniture') && (allowChangeWardrobePosition && this.ManageData.hasWardrobe && this.ManageData.isInside) || (allowChangeStoragePosition && this.ManageData.hasStorage && this.ManageData.isInside)))) ? `
                <span>${translation.manage.side_menu['section:management']} <div class="separator"></div></span>
                ${this.HasPermission('billPayments') ? `
                    <li class="element" data-href="bills">
                        <i class="fa-solid fa-file-invoice"></i>
                        <p class="label">${translation.manage.side_menu['option:bills']}</p>
                    </li>
                ` : ''}
                ${this.HasPermission('keysManage') ? `
                    <li class="element" data-href="keys">
                        <i class="fa-solid fa-key"></i>
                        <p class="label">${translation.manage.side_menu['option:keys']}</p>
                    </li>
                ` : ''}
                ${(this.ManageData && (this.ManageData.isOwner || this.ManageData.isRenter)) ? `
                    <li class="element" data-href="permissions">
                        <i class="fa-solid fa-user-shield"></i>
                        <p class="label">${translation.manage.side_menu['option:permissions']}</p>
                    </li>
                ` : ''}
                ${this.HasPermission('upgradesManage') ? `
                    <li class="element" data-href="upgrades">
                        <i class="fa-solid fa-turn-up"></i>
                        <p class="label">${translation.manage.side_menu['option:upgrades']}</p>
                    </li>
                ` : ''}
                ${(this.HasPermission('furniture') && allowChangeWardrobePosition && this.ManageData && this.ManageData.hasWardrobe && this.ManageData.isInside) ? `
                    <li class="element" data-href="change-wardrobe-position">
                        <i class="fa-solid fa-shirt"></i>
                        <p class="label">${translation.manage.side_menu['option:wardrobe_position']}</p>
                    </li>
                ` : ''}
                ${(this.HasPermission('furniture') && allowChangeStoragePosition && this.ManageData && this.ManageData.hasStorage && this.ManageData.isInside) ? `
                    <li class="element" data-href="change-storage-position">
                        <i class="fa-solid fa-boxes-stacked"></i>
                        <p class="label">${translation.manage.side_menu['option:storage_position']}</p>
                    </li>
                ` : ''}
                ${(this.ManageData && this.ManageData.isRenter) ? `
                    <li class="element" data-href="move_out">
                        <i class="fa-solid fa-boxes-packing"></i>
                        <p class="label">${translation.manage.side_menu['option:move_out']}</p>
                    </li>
                ` : ''}
            ` : ''}
            
            ${(this.HasPermission('marketplaceManage') || this.HasPermission('rent') || this.HasPermission('sell') || this.HasPermission('automaticSell')) ? `
                <span>${translation.manage.side_menu['section:marketplace']} <div class="separator"></div></span>
                ${this.HasPermission('marketplaceManage') ? `
                    <li class="element" data-href="marketplace">
                        <i class="fa-solid fa-shop"></i>
                        <p class="label">${translation.manage.side_menu['option:marketplace']}</p>
                    </li>
                ` : ''}
                ${this.HasPermission('rent') ? `
                    <li class="element" data-href="rent-out">
                        <i class="fa-solid fa-file-signature"></i>
                        <p class="label">${translation.manage.side_menu['option:rent_out']}</p>
                    </li>
                ` : ''}
                ${this.HasPermission('sell') ? `
                    <li class="element" data-href="transfer">
                        <i class="fa-solid fa-people-arrows"></i>
                        <p class="label">${translation.manage.side_menu['option:property_transfer']}</p>
                    </li>
                ` : ''}
                ${this.HasPermission('automaticSell') ? `
                    <li class="element" data-href="sell">
                        <i class="fa-solid fa-dollar-sign"></i>
                        <p class="label">${translation.manage.side_menu['option:sell']}</p>
                    </li>
                ` : ''}
            ` : ''}
        `);

        $('.housing_manage').fadeIn(120);

        if (this.ManageData && this.ManageData.isDevice) {
            updateSection('.housing_manage', 'order-furniture', `.housing_manage li[data-href="order-furniture"]`);
        } else {
            updateSection('.housing_manage', firstMenu, `.housing_manage li[data-href="${firstMenu}"]`);
        }
    },

    OpenManage: function (data) {
        this.ManageData = data.data;

        $('.housing_manage>div>.menu>#modal').hide();
        $(`.housing_manage #modal #header > #title, .housing_manage #modal #description, .housing_manage #modal #description-actions, .housing_manage #modal #buttons`).empty();
        
        $('.housing_manage').removeClass('isDevice');
        if (this.ManageData && this.ManageData.isDevice) {
            $('.housing_manage').addClass('isDevice');
        }
        
        if (this.ManageData && !this.ManageData.isDevice) {
            // Alerts:
            let alertsHTML = '';
            
            if (this.ManageData.unpaidBills) {
                if (this.ManageData.unpaidBills >= allowedUnpaidBills) {
                    alertsHTML += (AlertTemplate).format(
                        'error',
                        'fa-solid fa-triangle-exclamation',
                        translation.manage.main['alert_bill:title.services_blocked'],
                        translation.manage.main['alert_bill:description.services_blocked']
                    );
                } else if (this.ManageData.unpaidBills === allowedUnpaidBills - 1) {
                    alertsHTML += (AlertTemplate).format(
                        'error',
                        'fa-solid fa-triangle-exclamation',
                        translation.manage.main['alert_bill:title.last_chance'],
                        translation.manage.main['alert_bill:description.last_chance']
                    );
                } else if (this.ManageData.unpaidBills >= 1) {
                    alertsHTML += (AlertTemplate).format(
                        'warn',
                        'fa-solid fa-triangle-exclamation',
                        translation.manage.main['alert_bill:title.unpaid_bills'],
                        translation.manage.main['alert_bill:description.unpaid_bills']
                    );
                }
            }

            if (this.ManageData.renter && this.ManageData.unpaidRentBills >= 1) {
                alertsHTML += (AlertTemplate).format(
                    'info',
                    'fa-solid fa-receipt',
                    translation.manage.main['alert_rent:title.rent_due'],
                    translation.manage.main['alert_rent:description.rent_due']
                );
            }

            if (/*this.ManageData.isRenter &&*/ this.ManageData.rental && this.ManageData.rental.terminateAtPeriod) {
                alertsHTML += (AlertTemplate).format(
                    'warn',
                    'fa-solid fa-person-walking-luggage',
                    translation.manage.main['alert_rent:title.ending_soon'],
                    translation.manage.main['alert_rent:description.ending_soon']
                );
            }

            if (alertsHTML.length > 0) {
                $('.housing_manage div[data-type="my-house"]>div>.side-boxes>.box>.options>.alerts').html(alertsHTML).show();
            } else {
                $('.housing_manage div[data-type="my-house"]>div>.side-boxes>.box>.options>.alerts').hide();
            }
            
            // Main Informations:
            let mainInfosHTML = '';
            if (this.ManageData.address) {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-location-dot', translation.manage.main['card_address:label'], this.ManageData.address);
            };
            
            if (this.ManageData.region) {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-map-location-dot', translation.manage.main['card_region:label'], this.ManageData.region);
            };

            if (this.ManageData.garage) {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-warehouse', translation.manage.main['card_garage:label'], translation.manage.main['card_garage:description.has']);  
            } else if (this.ManageData.parking) {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-warehouse', translation.manage.main['card_parking:label'], (translation.manage.main['card_parking:description']).format(this.ManageData.parking));
            } else {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-warehouse', translation.manage.main['card_garage:label'], translation.manage.main['card_garage:description.none']);
            }
           
            if (this.ManageData.lastEnter && this.ManageData.lastEnter >= 1) {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-door-open', translation.manage.main['card_last_entrance:label'], `${formatDate(this.ManageData.lastEnter).date} ${formatDate(this.ManageData.lastEnter).time}`);
            } else {
                mainInfosHTML = mainInfosHTML + (ManageElementTemplate).format('fa-solid fa-door-open', translation.manage.main['card_last_entrance:label'], translation.manage.main['card_last_entrance:description.no_information']);
            }
            
            $('.housing_manage div[data-type="my-house"] > div > .side-boxes > .box > .options > .informations').html(mainInfosHTML);

            // Renter Informations:
            $('.housing_manage div[data-type="my-house"] > div > .side-boxes > .box > .options > .renter').hide();
            if (this.HasPermission('rentersManage')  && this.ManageData.rental && this.ManageData.renter) {
                $('.housing_manage div[data-type="my-house"] > div > .side-boxes > .box > .options > .renter > .informations > .value').html(this.ManageData.renterName);
                $('.housing_manage div[data-type="my-house"] > div > .side-boxes > .box > .options > .renter').show();
            }
    
            // Bills:
            if (this.HasPermission('billPayments')) {
                if (useServiceBills) {
                    let billsPricesHTML = '';
                    let billsQuantity = 0;
            
                    if (this.ManageData.electricity && this.ManageData.electricity.rate) {
                        billsQuantity++;
                        billsPricesHTML = billsPricesHTML + (ManageBillElementTemplate).format('fa-solid fa-bolt', translation.manage.bills['card_electricity:label'], translation.currency, formatNumber(this.ManageData.electricity.rate, 2, 4), `/${this.ManageData.electricity.unit}`);
                    };
                    
                    if (this.ManageData.water && this.ManageData.water.rate) {
                        billsQuantity++;
                        billsPricesHTML = billsPricesHTML + (ManageBillElementTemplate).format('fa-solid fa-droplet', translation.manage.bills['card_water:label'], translation.currency, formatNumber(this.ManageData.water.rate, 2, 4), `/${this.ManageData.water.unit}`);
                    };
        
                    if (this.ManageData.internet && this.ManageData.internet.flatRate) {
                        billsQuantity++;
                        billsPricesHTML = billsPricesHTML + (ManageBillElementTemplate).format('fa-solid fa-wifi', translation.manage.bills['card_internet:label'], translation.currency, formatNumber(this.ManageData.internet.flatRate, 2, 4), '');
                    };
            
                    $('.housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-info').html(billsPricesHTML).css('grid-template-columns', `repeat(${billsQuantity}, 1fr)`);
                } else {
                    $('.housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-info').hide();
                    $('.housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-list').css('margin-top', '-1em');
                    $('.housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-list > table > tbody').css('max-height', '47em');
                }

                this.UpdateManage({type: 'bills'});
            }

            if (this.ManageData.isOwner || this.ManageData.isRenter) this.UpdateManage({type: 'permissions'});
            if (this.HasPermission('keysManage')) this.UpdateManage({type: 'keys'});
            if (this.HasPermission('furniture')) this.UpdateManage({type: 'furniture'});
            if (this.HasPermission('upgradesManage')) this.UpdateManage({type: 'upgrades'});
            if (this.HasPermission('marketplaceManage')) this.UpdateManage({type: 'marketplace'});
        }

        if (this.HasPermission('furniture') && requirePurchaseFurniture) {
            this.UpdateManage({type: 'ordered-furniture'})
            let orderFurnitureHTML = '';
            for (const [model, value] of Object.entries(this.FurnitureList)) {
                if (value.isOutdoor && data.data.allowedOutside || value.isIndoor && data.data.allowedInside) {
                    orderFurnitureHTML += `
                        <div
                            data-tag="${value.tag}"
                            data-price="${value.price}"
                            data-is-inside="${value.isIndoor ? "1" : '0'}"
                            data-is-outside="${value.isOutdoor ? "1" : '0'}"
                        >
                            ${value.interactableName ? `<div class="info">${translation.manage.order['tag:label.interactable']}</div>` : ''}
                            <img src="./images/furniture/${model}.webp" draggable="false">
                            <div class="name">${value.label || model}</div>
                            <div class="price">${translation.manage.order['description.price']} ${translation.currency}${formatNumber(value.price, 0, 0)}</div>
                            <div class="clickable-btn button" data-action="order-furniture" data-model="${model}">${translation.manage.order['buttons:label.purchase']}</div>
                        </div>
                    `;
                }
            }
            $('.housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-list').html(orderFurnitureHTML);

            $('.housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-filters > #search > input').val('')
            $('.housing_manage div[data-type="order-furniture"] select[name="furniture-tag"]').val("0");
            $('.housing_manage div[data-type="order-furniture"] select[name="furniture-environment"]').val("0");
        }

        // data.data.autoSellPrice
        
        currentMenu = 'housing_manage';
        this.LoadManageMenu();
    },

    UpdateManage: function (data) {
        if (data.type == 'bills') {
            if (data.forcedUpdate) {
                this.ManageData['unpaidBills'] = data.unpaidBills;
                if (this.HasPermission('billPayments')) this.ManageData['bills'] = data.bills;
            }

            if (this.HasPermission('billPayments') && this.ManageData['bills']) {
                let billsListHTML = '';
                this.ManageData['bills'].forEach(element => {
                    let status = ''
                    if (element.type == 'rent') {
                        status = element.paid == 1 && 'paid' || 'unpaid';
                    } else {
                        status = element.paid == 1 && 'paid' || element.period == getCurrentPeriod() && 'upcoming' || 'unpaid';
                    }

                    billsListHTML += `
                        <tr>
                            <td>
                                <div class="status-tag ${status}">
                                    ${
                                        status === 'upcoming' && translation.manage.bills['status.upcoming'] ||
                                        status === 'paid' && translation.manage.bills['status.paid'] ||
                                        status === 'unpaid' && translation.manage.bills['status.unpaid']
                                    }
                                </div>
                            </td>
                            <td>${formatPeriod(element.period)}</td>
                            <td>${element.type == 'rent' ? translation.manage.bills['type.rent'] : translation.manage.bills['type.services']}</td>
                            <td>
                                <div class="view-details" data-period="${element.period}" data-type="${element.type}"><i class="fa-solid fa-eye"></i> ${translation.manage.bills['buttons:label.view_details']}</div>
                            </td>
                        </tr>
                    `;
                });
                $('.housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-list > table > tbody').html(billsListHTML);
            }

        } else if (data.type == 'keys') {
            if (!this.HasPermission('keysManage')) return;
            
            if (data.forcedUpdate) {
                this.ManageData['keys'] = data.keys;
            }

            let keysListHTML = '';
            let keysHTML = '';
            keysHTML = keysHTML + (ManageKeysElementTemplate).format(
                'fa-solid fa-key',
                translation.manage.keys['card_key:label'],
                `
                    <div class="value">${Object.keys(this.ManageData['keys']).length}<span>/${this.ManageData.keysLimit || keysLimit}</span></div>
                    ${keysOnItem ?
                        `<div class="clickable-btn button" data-action="buy-key">${(translation.manage.keys['buttons:label.order_key']).format(translation.currency, formatNumber(keyPrice, 0, 0))}</div>`
                        :
                        `<div class="clickable-btn button" data-action="give-key">${translation.manage.keys['buttons:label.give_key']}</div>`
                    }
                `
            );
            if (keysOnItem) {
                keysHTML = keysHTML + (ManageKeysElementTemplate).format(
                    'fa-solid fa-user-lock',
                    translation.manage.keys['card_lock_replacement:label'],
                    `<div class="value">${translation.manage.keys['card_lock_replacement:description']}</div><div class="clickable-btn button" data-action="lock-replacement">${(translation.manage.keys['card_lock_replacement:button']).format(translation.currency, formatNumber(lockReplacementPrice, 0, 0))}</div>`
                );
            }
            $('.housing_manage div[data-type="keys"] > div > .side-boxes > .box > .keys-info').html(keysHTML);
            $('.housing_manage div[data-type="keys"] > div > .side-boxes > .box > .keys-list > table > thead th#actions').hide();
            
            if (keysOnItem) {
                for (const [id, keySerial] of Object.entries(this.ManageData['keys'])) {
                    keysListHTML += `
                        <tr>
                            <td>${keySerial}</td>
                            <td></td>
                        </tr>
                    `;
                }
            } else {
                $('.housing_manage div[data-type="keys"] > div > .side-boxes > .box > .keys-list > table > thead th#actions').show();
                for (const [identifier, playerName] of Object.entries(this.ManageData['keys'])) {
                    keysListHTML += `
                        <tr>
                            <td>${playerName}</td>
                            <td>
                                <div class="clickable-btn remove-key" data-action="remove-key" data-identifier="${identifier}"><i class="fa-solid fa-trash-can"></i> ${translation.manage.keys['table:button.remove']}</div>
                            </td>
                        </tr>
                    `;
                }
            }
            
            $('.housing_manage div[data-type="keys"] > div > .side-boxes > .box > .keys-list > table > tbody').html(keysListHTML);
        } else if (data.type == 'permissions') {
            if (!this.ManageData.isOwner && !this.ManageData.isRenter) return;

            if (data.forcedUpdate) {
                this.ManageData['permissions'] = data.permissions;
            }
            
            let permissionsPlayersHTML = `
                <div class="create-new-permission clickable-btn" data-action="create-permission">
                    <i class="fa-solid fa-user-plus"></i>
                </div>
            `;
    
            for (const [identifier, permissions] of Object.entries(this.ManageData['permissions'])) {
                permissionsPlayersHTML += `
                    <div>
                        <div class="icon">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <div class="informations">
                            <div class="label">${permissions._name}</div>
                            <div class="buttons">
                                <div class="clickable-btn button" data-action="manage-permission" data-identifier="${identifier}">${translation.manage.permissions['buttons:label.manage']}</div>
                                <div class="clickable-btn button" data-action="remove-permission" data-identifier="${identifier}">${translation.manage.permissions['buttons:label.remove']}</div>
                            </div>
                        </div>
                    </div>
                `;
            }
    
            $('.housing_manage div[data-type="permissions"]>div>.side-boxes>.box>.permissions-players').html(permissionsPlayersHTML);

        } else if (data.type == 'furniture') {
            if (!this.HasPermission('furniture')) return;
            
            if (data.forcedUpdate) {
                this.ManageData['furniture'] = data.furniture;
            }

            let furnitureListHTML = '';
            let furnitureHTML = '';
            furnitureHTML = furnitureHTML + (ManageFurnitureElementTemplate).format('', 'fa-solid fa-chair', translation.manage.furniture['card_furniture:label'], `<div class="value">${this.ManageData.furniture ? this.ManageData.furniture.length : 0}<span>/${this.ManageData.furnitureLimit}</span></div>`);
            if (requirePurchaseFurniture) {
                furnitureHTML = furnitureHTML + (ManageFurnitureElementTemplate).format('ikea', 'fa-solid fa-truck', translation.manage.furniture['card_furnistock:label'], `<div class="value">${translation.manage.furniture['card_furnistock:description']}</div>`);
                $('.housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-info').css('grid-template-columns', 'repeat(2, 1fr)');
            }
            $('.housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-info').html(furnitureHTML);
            if (this.ManageData.furniture) {
                for (const [key, value] of Object.entries(this.ManageData.furniture)) {
                    if ((value.stored == 1 && !value.metadata?.deliveryTime) || value.position?.environment) {
                        furnitureListHTML += `
                            <tr>
                                <td>
                                    <div class="furniture-environment-tag ${value.position?.environment || 'storage'}">${
                                        value.position?.environment == 'inside' && translation.manage.furniture['table:environment_tag.inside'] ||
                                        value.position?.environment == 'outside' && translation.manage.furniture['table:environment_tag.outside'] ||
                                        translation.manage.furniture['table:environment_tag.storage']
                                    }</div>
                                </td>
                                <td>${this.FurnitureList[value.model] && this.FurnitureList[value.model].label || value.model}</td>
                                <td>
                                    ${!value.position?.environment ? `
                                        <div class="clickable-btn sell" data-action="sell-furniture" data-furniture-id="${value.id}" data-model="${value.model}"><i class="fa-solid fa-dollar-sign"></i> ${translation.manage.furniture['table:button.sell']}</div>
                                        <div class="clickable-btn remove" data-action="remove-furniture" data-furniture-id="${value.id}" data-model="${value.model}"><i class="fa-solid fa-trash-can"></i> ${translation.manage.furniture['table:button.remove']}</div>
                                    ` : ''}
                                    ${value.position?.environment ? `<div class="clickable-btn take-to-storage" data-action="take-to-storage" data-furniture-id="${value.id}"><i class="fa-solid fa-box-open"></i> ${translation.manage.furniture['table:button.take_to_storage']}</div>` : ''}
                                </td>
                            </tr>
                        `;
                    }
                }
            }
            $('.housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-list > table > tbody').html(furnitureListHTML);
        } else if (data.type == 'ordered-furniture') {
            if (!this.HasPermission('furniture')) return;
            
            if (data.forcedUpdate) {
                this.ManageData['furniture'] = data.furniture;
                this.UpdateManage({type: 'furniture'})
            }

            if (data.forcedClose) {
                $('.housing_manage>div>.menu>#order-furniture-menu').fadeOut(120);
                setTimeout(() => {
                    $(`
                        .housing_manage>div>.menu>#order-furniture-menu>div>.data>.image,
                        .housing_manage>div>.menu>#order-furniture-menu>div>.data>.informations,
                        .housing_manage>div>.menu>#order-furniture-menu>div>.buttons
                    `).empty();
                }, 150);
            }

            let ordersListHTML = '';
            if (this.ManageData.furniture) {
                for (const [key, value] of Object.entries(this.ManageData.furniture)) {
                    if ((value.stored == 1 && (value.metadata?.deliveryTime || value.metadata?.delivered))) {
                        ordersListHTML += `
                            <tr>
                                <td>${getDeliveryStatus(value.metadata?.deliveryTime)}</td>
                                <td>${this.FurnitureList[value.model] && this.FurnitureList[value.model].label || value.model}</td>
                            </tr>
                        `;
                    }
                }
            }
            
            $('.housing_manage div[data-type="orders-list"] > div > .side-boxes > .box > .furniture-list > table > tbody').html(ordersListHTML);
        } else if (data.type == 'upgrades') {
            if (!this.HasPermission('upgradesManage')) return;

            if (data.forcedUpdate) {
                this.ManageData['ownUpgrades'] = data.ownUpgrades;
                this.ManageData['furnitureLimit'] = data.furnitureLimit;

                if (this.HasPermission('furniture')) {
                    let furnitureHTML = '';
                    furnitureHTML = furnitureHTML + (ManageFurnitureElementTemplate).format('', 'fa-solid fa-chair', translation.manage.furniture['card_furniture:label'], `<div class="value">${this.ManageData.furniture ? this.ManageData.furniture.length : 0}<span>/${this.ManageData.furnitureLimit}</span></div>`);
                    if (requirePurchaseFurniture) {
                        furnitureHTML = furnitureHTML + (ManageFurnitureElementTemplate).format('ikea', 'fa-solid fa-truck', translation.manage.furniture['card_furnistock:label'], `<div class="value">${translation.manage.furniture['card_furnistock:description']}</div>`);
                        $('.housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-info').css('grid-template-columns', 'repeat(2, 1fr)');
                    }
                    $('.housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-info').html(furnitureHTML);
                }
            }
            
            let upgradesHTML = '';
            for (const [key, value] of Object.entries(this.ManageData.upgrades)) {
                upgradesHTML += `
                    <div>
                        <div class="icon">
                            <i class="${value.icon}"></i>
                        </div>

                        <div class="informations">
                `

                if (value.levels) {
                    let levelsElements = '';
                    for (const [levelId, levelData] of Object.entries(value.levels)) {
                        let levelClass = '';
                        if (this.ManageData.ownUpgrades[value.metadata] != undefined) {
                            if (Number(this.ManageData.ownUpgrades[value.metadata]) === Number(levelId)) {
                                levelClass = 'current-level';
                            } else if (Number(this.ManageData.ownUpgrades[value.metadata]) > Number(levelId)) {
                                levelClass = 'previous-level';
                            }
                        }
                        levelsElements += `<div class="${levelClass}"></div>`;
                    }

                    let nextLevelData = null;
                    let nextLevelDescription = null;
                    if (!this.ManageData.ownUpgrades[value.metadata]) {
                        nextLevelData = value.levels['1'];
                        nextLevelDescription = value.description;
                    } else if (value.levels[String(Number(this.ManageData.ownUpgrades[value.metadata]) + 1)]) {
                        nextLevelData = value.levels[String(Number(this.ManageData.ownUpgrades[value.metadata]) + 1)];
                    } else {
                    }

                    upgradesHTML += `
                        ${nextLevelData ? `<div class="price">${translation.manage.upgrades['price']} ${translation.currency}${formatNumber(nextLevelData.price, 0, 0)}</div>` : ''}
                        <div class="levels">${levelsElements}</div>
                        <div class="label">${value.label}</div>
                        <div class="description">${nextLevelDescription || value.levels[this.ManageData.ownUpgrades[value.metadata]].description}</div>
                        ${nextLevelData ? `<div class="clickable-btn button" data-action="purchase-upgrade" data-name="${key}">${translation.manage.upgrades['button']}</div>` : ''}
                    `;
                } else {
                    upgradesHTML += `
                        <div class="price">${translation.manage.upgrades['price']} ${translation.currency}${formatNumber(value.price, 0, 0)}</div>
                        <div class="label">${value.label}</div>
                        <div class="description">${value.description}</div>
                        ${!this.ManageData.ownUpgrades[value.metadata] ? `<div class="clickable-btn button" data-action="purchase-upgrade" data-name="${key}">${translation.manage.upgrades['button']}</div>` : ''}
                    `;
                }
                            
                upgradesHTML += `
                        </div>
                    </div>
                `;
                // levels
            }
            $('.housing_manage div[data-type="upgrades"] > div > .side-boxes > .box > .options').html(upgradesHTML);
        } else if (data.type == 'marketplace') {
            if (!this.HasPermission('marketplaceManage')) return;

            if (data.forcedUpdate) {
                if (!data.onlyPhotos) {
                    this.ManageData['furnished'] = data.furnished;
                    this.ManageData['contact_number'] = data.contact_number;
                    this.ManageData['description'] = data.description;
                    this.ManageData['sale'] = data.sale;
                    this.ManageData['rental'] = data.rental;
                }
                this.ManageData['images'] = data.images;

                if (data.closeModal) {
                    Property.CloseModal()
                }
            }

            let marketplaceHTML = `
                <div class="images">
                    <div class="icon">
                        <i class="fa-solid fa-image"></i>
                    </div>
                    <div class="informations">
                        <div class="label">
                            <label for="manage-description" class="input-name">${translation.manage.marketplace['option:images']}</label>
                        </div>
                        <div class="images-list">
                            <div id="add-image" data-image-id="1" ${this.ManageData?.images?.['1'] && `style="background-image: url(${this.ManageData.images['1']});border: none;"` || ''}>
                                <i class="fa-solid fa-plus" ${!this.ManageData?.images?.['1'] ? `style="opacity:1.0;"` : ''}></i>
                            </div>
                            <div class="second-image">
                                <div id="add-image" data-image-id="2" ${this.ManageData?.images?.['2'] && `style="background-image: url(${this.ManageData.images['2']});border: none;"` || ''}>
                                    <i class="fa-solid fa-plus" ${!this.ManageData?.images?.['2'] ? `style="opacity:1.0;"` : ''}></i>
                                </div>
                                <div id="add-image" data-image-id="3" ${this.ManageData?.images?.['3'] && `style="background-image: url(${this.ManageData.images['3']});border: none;"` || ''}>
                                    <i class="fa-solid fa-plus" ${!this.ManageData?.images?.['3'] ? `style="opacity:1.0;"` : ''}></i>
                                </div>
                                <div id="add-image" data-image-id="4" ${this.ManageData?.images?.['4'] && `style="background-image: url(${this.ManageData.images['4']});border: none;"` || ''}>
                                    <i class="fa-solid fa-plus" ${!this.ManageData?.images?.['4'] ? `style="opacity:1.0;"` : ''}></i>
                                </div>
                                <div id="add-image" data-image-id="5" ${this.ManageData?.images?.['5'] && `style="background-image: url(${this.ManageData.images['5']});border: none;"` || ''}>
                                    <i class="fa-solid fa-plus" ${!this.ManageData?.images?.['5'] ? `style="opacity:1.0;"` : ''}></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            
                <div class="description ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}">
                    <div class="icon">
                        <i class="fa-solid fa-file-lines"></i>
                    </div>
                    <div class="informations">
                        <div class="label">
                            <label for="manage-description" class="input-name">${translation.manage.marketplace['option:description']}</label>
                        </div>
                        <textarea class="value" ${this.IsOfferAtMarketplace() ? 'disabled' : ''}>${this.ManageData.description}</textarea>
                    </div>
                </div>

                <div class="furnished ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}">
                    <div class="icon">
                        <i class="fa-solid fa-chair"></i>
                    </div>
                    <div class="informations">
                        <div class="label">
                            <div class="checkbox-wrapper-46">
                                <input type="checkbox" id="manage-furnished" class="inp-cbx ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}" data-toggle="manage-furnished" ${this.ManageData.furnished ? 'checked' : ''}/>
                                <label for="manage-furnished" class="cbx">
                                    <span>
                                        <svg viewBox="0 0 12 10" height="10px" width="12px">
                                            <polyline points="1.5 6 4.5 9 10.5 1"></polyline>
                                        </svg>
                                    </span>
                                    <label for="manage-furnished" class="input-name">${translation.manage.marketplace['option:furnished']}</label>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="contact-number ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}">
                    <div class="icon">
                        <i class="fa-solid fa-phone"></i>
                    </div>
                    <div class="informations">
                        <div class="label">
                            <label for="manage-contact-number" class="input-name">${translation.manage.marketplace['option:contact_number']}</label>
                        </div>
                        <input class="value" value="${this.ManageData.contact_number || ''}" ${this.IsOfferAtMarketplace() ? 'disabled' : ''}></input>
                    </div>
                </div>
                
                <div class="sale ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}">
                    <div class="icon">
                        <i class="fa-solid fa-tag"></i>
                    </div>
                    <div class="informations">
                        <div class="label">
                            <div class="checkbox-wrapper-46">
                                <input type="checkbox" id="manage-purchase-price" class="inp-cbx ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}" data-toggle="manage-purchase-price" ${this.ManageData.sale.active ? 'checked' : ''}/>
                                <label for="manage-purchase-price" class="cbx">
                                    <span>
                                        <svg viewBox="0 0 12 10" height="10px" width="12px">
                                            <polyline points="1.5 6 4.5 9 10.5 1"></polyline>
                                        </svg>
                                    </span>
                                    <label for="manage-purchase-price" class="input-name">${translation.manage.marketplace['option:purchase_price']}</label>
                                </label>
                            </div>
                        </div>
                        <input class="value" value="${this.ManageData.sale.price || 0}" ${this.IsOfferAtMarketplace() ? 'disabled' : ''}></input>
                    </div>
                </div>
                
                <div class="rental ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}">
                    <div class="icon">
                        <i class="fa-solid fa-tags"></i>
                    </div>
                    <div class="informations">
                        <div class="label">
                            <div class="checkbox-wrapper-46">
                                <input type="checkbox" id="manage-rental-price" class="inp-cbx ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}" data-toggle="manage-rental-price" ${this.ManageData.rental.active ? 'checked' : ''}/>
                                <label for="manage-rental-price" class="cbx">
                                    <span>
                                        <svg viewBox="0 0 12 10" height="10px" width="12px">
                                            <polyline points="1.5 6 4.5 9 10.5 1"></polyline>
                                        </svg>
                                    </span>
                                    <label for="manage-rental-price" class="input-name">${translation.manage.marketplace['option:rental_price']}</label>
                                </label>
                            </div>
                        </div>
                        <input class="value" value="${this.ManageData.rental.price || 0}" ${this.IsOfferAtMarketplace() ? 'disabled' : ''}></input>
                    </div>
                </div>
            `;
            $('.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box > .options').html(marketplaceHTML);
            
            let marketplaceButtonsHTML = `
                <div data-type="marketplace">
                    <div class="icon">
                        <i class="fa-solid fa-tags"></i>
                    </div>
                    <div class="informations">
                        <div class="label">${translation.manage.marketplace['card:label']}</div>
                        <div class="description">${translation.manage.marketplace['card:description']}</div>
                        <div class="buttons">
                            <div class="clickable-btn button ${!this.IsOfferAtMarketplace() ? 'not-allowed' : ''}" data-action="marketplace-remove">${translation.manage.marketplace['card:buttons.take_down']}</div>
                            <div class="clickable-btn button ${this.IsOfferAtMarketplace() ? 'not-allowed' : ''}" data-action="marketplace-add">${translation.manage.marketplace['card:buttons.put_on']}</div>
                        </div>
                    </div>
                </div>
            `
            $('.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box > .buttons').html(marketplaceButtonsHTML);
        } else if (data.type == 'rental-termination') {
            if (data.forcedUpdate) {
                if (data.metadata) {
                    this.ManageData['renter'] = null;
                    this.ManageData['renterName'] = null;
                    this.ManageData['permissions'] = data.permissions;
                    this.ManageData['keys'] = data.keys;
                    this.ManageData['metadata'] = data.metadata;
                    this.ManageData['bills'] = data.bills;
                }
                this.ManageData['rental'] = data.rental;
            }

            if (this.HasPermission('rentersManage') || this.HasPermission('billPayments') || this.HasPermission('keysManage')) { 
                if (!this.ManageData['renter']) {
                    $('.housing_manage div[data-type="my-house"] > div > .side-boxes > .box > .options > .renter').hide();
                    this.UpdateManage({type: 'bills'});
                    this.UpdateManage({type: 'keys'});
                    this.UpdateManage({type: 'permissions'});
                }
            }
        }
    },

    CloseManage: function () {
        $(`
            .housing_manage,
            .housing_manage>div>.menu>#order-furniture-menu
        `).fadeOut(120)

        $(`
            .housing_manage>div>.menu>#order-furniture-menu>div>.data>.image,
            .housing_manage>div>.menu>#order-furniture-menu>div>.data>.informations,
            .housing_manage>div>.menu>#order-furniture-menu>div>.buttons,
            .housing_manage div[data-type="my-house"] > div > .side-boxes > .box > .options > .informations,
            .housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-info,
            .housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-list,
            .housing_manage div[data-type="upgrades"] > div > .side-boxes > .box > .options,
            .housing_manage div[data-type="keys"] > div > .side-boxes > .box > .keys-info,
            .housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-info,
            .housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-list > table > tbody,
            .housing_manage div[data-type="orders-list"] > div > .side-boxes > .box > .furniture-list > table > tbody
        `).empty();
        
        currentMenu = null;
    },


    ReloadAvailableFurniture: function (data) {
        this.FurnitureList = data.data;
    },

    OpenFurniture: function (data) {
        $('.property_furniture > div > .menu > #categories > #elements > div').removeClass('active');

        let furniture = `
            <div data-id="edit">
                <div class="label">
                    <p class="name">${translation.furniture.selection['option.edit_furniture']}</p>
                </div>
                <img src="./images/edit_furniture.webp" draggable="false">
            </div>
        `;
        
        if (requirePurchaseFurniture) {
            // Initialize ManageData if it doesn't exist
            if (!this.ManageData) {
                this.ManageData = {};
            }
            this.ManageData['furniture'] = data.data.propertyFurniture || [];
            for (const [_, v] of Object.entries(this.ManageData['furniture'])) {
                // Skip if furniture doesn't exist in FurnitureList
                if (!this.FurnitureList[v.model]) {
                    continue;
                }
                
                if (
                    !v.metadata?.deliveryTime &&
                    !v.metadata?.delivered &&
                    !v.position &&
                    (
                        (data.data.isInside && this.FurnitureList[v.model].isIndoor) ||
                        (data.data.isOutside && this.FurnitureList[v.model].isOutdoor)
                    )
                ) {
                    furniture += `
                        <div data-tag="${this.FurnitureList[v.model].tag || ''}" data-model="${v.model}" data-id="${v.id}">
                            <div class="label">
                                <p class="name">${this.FurnitureList[v.model].label || v.model}</p>
                            </div>
                            
                            <div class="label-second">
                                <p class="id">#${v.id}</p>
                            </div>
                            
                            <img src="./images/furniture/${v.model}.webp" draggable="false">
                        </div>
                    `;
                }
            }
        } else {
            for (const [model, v] of Object.entries(this.FurnitureList)) {
                if ((data.data.isInside && v.isIndoor && data.data.allowedInside) || (data.data.isOutside && v.isOutdoor && data.data.allowedOutside)) {
                    furniture += `
                        <div data-tag="${v.tag}" data-model="${model}">
                            <div class="label">
                                <p class="name">${v.label || model}</p>
                            </div>

                            <div class="label-second">
                                <p class="price">${translation.currency} ${v.price}</p>
                            </div>

                            <img src="./images/furniture/${model}.webp" draggable="false">
                        </div>
                    `;
                }
            }
        }

        if (data.data.allowChangeThemePurchased && data.data.ipl && HousingCreator.AvailableIPLS[data.data.ipl]?.settings?.Themes) {
            for (const [name, value] of Object.entries(HousingCreator.AvailableIPLS[data.data.ipl].settings.Themes)) {
                furniture += `
                    <div data-tag="theme" data-theme="${name}" style="display:none;">
                        <div class="label">
                            <p class="name">${value.label}</p>
                        </div>

                        <div class="label-second">
                            <p class="price">${translation.currency} ${value.price}</p>
                        </div>

                        <img src="./images/${value.image}" draggable="false">
                    </div>
                `;
            }
            $(`.property_furniture>div>.menu>#categories > #elements > div[data-tag="theme"]`).show();

        } else {
            $(`.property_furniture>div>.menu>#categories > #elements > div[data-tag="theme"]`).hide();

        }

        $('.property_furniture #items > #elements').html(furniture);

        $('.property_furniture').fadeIn(120);
    },

    CloseFurniture: function () {
        $(`.property_furniture`).fadeOut(120);
        $('.property_furniture #items > #elements').empty();
        ControlsMenu({toggle: false});        
        currentMenu = null;
    },

    FurniturePlace: function () {
        $(`.property_furniture`).fadeOut(120);
    },

    OpenFurniturePurchase: function (data) {
        $('.property_furniture_purchase > .purchase > .name').text((translation.furniture['purchase:modal'].title).format(data.data.label, translation.currency, formatNumber(data.data.price, 0, 0)));
        $('.property_furniture_purchase').fadeIn(120);
        ControlsMenu({toggle: false});
    },

    CloseFurniturePurchase: function () {
        $('.property_furniture_purchase').fadeOut(120);
    },


    OpenDoorPeephole: function () {
        $('.door_peephole').show();
    },

    CloseDoorPeephole: function () {
        $('.door_peephole').hide();
    },


    IsOfferAtMarketplace: function() {
        return this.ManageData.sale.active || this.ManageData.rental.active;
    },


    ShowModal: function(title, description, actionsHTML, buttonsHTML) {
        $('.housing_manage>div>.menu>#modal>div>#header>#title').text(title);

        if (description) {
            $('.housing_manage>div>.menu>#modal>div>#description').html(description).show();
        } else {
            $('.housing_manage>div>.menu>#modal>div>#description').hide();
        }
        
        if (actionsHTML) {
            $('.housing_manage>div>.menu>#modal>div>#description-actions').html(actionsHTML).show();
        } else {
            $('.housing_manage>div>.menu>#modal>div>#description-actions').hide();
        }
        
        $('.housing_manage>div>.menu>#modal>div>#buttons').html(buttonsHTML);

        $('.housing_manage>div>.menu>#modal').fadeIn(120);
    },

    CloseModal: function() {
        $('.housing_manage>div>.menu>#modal').fadeOut(120);
    },

    UpgradeCompleted: function(data) {
        
        // Update ManageData with new values
        if (data.ownUpgrades) {
            this.ManageData.ownUpgrades = data.ownUpgrades;
        }
        if (data.furnitureLimit) {
            this.ManageData.furnitureLimit = data.furnitureLimit;
        }
        
        // Refresh the upgrades section to update levels and buttons
        this.UpdateManage({
            type: 'upgrades',
            forcedUpdate: true,
            ownUpgrades: data.ownUpgrades,
            furnitureLimit: data.furnitureLimit
        });
        
    },

    RefreshClosestPlayers: function(data) {
        let options = [
            {
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            },
        ]
        
        for (const [_, playerId] of Object.entries(data.data)) {
            options.push({
                id: playerId,
                text: (translation.contract.citizen).format(playerId),
                disabled: true,
                selected: true
            })
        }

        if ($('.contract').css('display') === 'block') {
            $('.contract .paragraph_text_1 > select#select-player').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: options
            });
        } else if (
            $('.housing_manage div[data-type="permissions"]').css('display') === 'block' ||
            $('.housing_manage div[data-type="keys"]').css('display') === 'block'
        ) {
            $('.housing_manage>div>.menu>#modal>div>#description-actions>select#select-player').select2({
                minimumResultsForSearch: Infinity,
                allowClear: false,
                data: options
            });
        }
    },


    ShowContract: function (data) {
        reloadContract(data.data.type, {
            data: data.data
        })
        $('.contract').fadeIn(150);
    }
}

const renderPermissionCheckbox = (perm, label, hasPerm, onlyOwner) => {
    if (onlyOwner) {
        if (!Property.ManageData.isOwner) return '';
    } else {
        if (!Property.ManageData.isOwner && !(Property.ManageData.isRenter && Property.ManageData.myPermissions?.[perm])) return '';
    }

    return `
        <div class="checkbox-wrapper-46">
            <input type="checkbox" id="permission-${perm}" class="inp-cbx" data-toggle="permission-${perm}" ${hasPerm ? 'checked' : ''}/>
            <label for="permission-${perm}" class="cbx">
                <span><svg viewBox="0 0 12 10" height="10px" width="12px"><polyline points="1.5 6 4.5 9 10.5 1"></polyline></svg></span>
                <label for="permission-${perm}" class="input-name">${label}</label>
            </label>
        </div>
    `;
};

const getPermissionCheckboxState = (perm) => {
    const el = $(`.housing_manage > div > .menu > #modal .inp-cbx[data-toggle="permission-${perm}"]`);
    return el.length ? el.prop('checked') : undefined;
};

$(document).on('click', '.property_offer .menu .main > .buttons > .view', function(e) {
    $.post(`https://${GetParentResourceName()}/propertyOffer:enterHouse`, JSON.stringify({apartmentId: Property.SelectedApartmentId, iplTheme: Property.SelectedTheme}));
})

function reloadContract(type, data) {
    if ($('.contract #make_signature_buyer').data('writing') || $('.contract #make_signature_seller').data('writing')) return;

    contractType = type;

    $('.contract .buttons').hide();
    $('.contract .buttons > div').removeClass('active');
    $('.contract .signatures #signature_seller, .contract .signatures #signature_buyer').text('');

    if (type == 'rent-out') {
        $('.contract .center#title').text(translation.contract['rent'].title);
        $('.contract .paragraph_1').text(translation.contract['rent'].paragraph_1_title);
        $('.contract .paragraph_2').text(translation.contract['rent'].paragraph_2_title);
        $('.contract .paragraph_3').text(translation.contract['rent'].paragraph_3_title);

        $('.contract .signatures .seller, .contract .signatures .buyer').show();
        $('.contract .signatures .seller > .signature-text').text(translation.contract.rent.landlord_signature);
        $('.contract .signatures .buyer > .signature-text').text(translation.contract.rent.lessee_signature);
        
        if (data.data.owner) {
            $('.contract .paragraph_text_1').html((translation.contract['rent'].paragraph_1_text).format(' ' + data.data.characterName, data.data.address));
            $('.contract .signatures .buyer > #make_signature_buyer').show();
            $('.contract .signatures .seller > #make_signature_seller').hide();
            $('.contract .paragraph_text_2').html((translation.contract['rent'].paragraph_2_text).format(
                data.data.rentCycle == 'weekly' ? translation.select_menu.rent_weekly : translation.select_menu.rent_monthly,
                translation.currency,
                formatNumber(Number(data.data.price), 2, 2),
                data.data.rentCycle == 'weekly' ? translation['time.week'] : translation['time.month'],
                allowedUnpaidRentBills,
                data.data.rentCycle == 'weekly' ? translation['time.weeks'] : translation['time.months'],
                data.data.paymentMethod == 'cash' ? translation.select_menu.payment_cash : translation.select_menu.payment_bank
            ));
            $('.contract .signatures #signature_seller').text(data.data.ownerName);
        } else {
            $('.contract .paragraph_text_1').html((translation.contract['rent'].paragraph_1_text).format('<select id="select-player"></select><div id="select-player-refresh"><i class="fa-solid fa-arrows-rotate"></i></div>', data.data.address));
            $('.contract .signatures .buyer > #make_signature_buyer').hide();
            $('.contract .signatures .seller > #make_signature_seller').show();
            $('.contract .paragraph_text_2').html((translation.contract['rent'].paragraph_2_text).format(
                `<select id="select-rent-cycle"></select>`,
                translation.currency,
                `<input id="input-price" placeholder="0" onkeydown="return isNumberKey(event)" onpaste="return false"></input>`,
                '<span id="cycle-1">...</span>',
                allowedUnpaidRentBills,
                '<span id="cycle-2">...</span>',
                `<select id="select-payment-method"></select>`
            ));
        }

        $.post(`https://${GetParentResourceName()}/getClosestPlayers`);

    } else if (type == 'transfer') {
        $('.contract .center#title').text(translation.contract['purchase'].title);
        $('.contract .paragraph_1').text(translation.contract['purchase'].paragraph_1_title);
        $('.contract .paragraph_2').text(translation.contract['purchase'].paragraph_2_title);
        $('.contract .paragraph_3').text(translation.contract['purchase'].paragraph_3_title);

        $('.contract .signatures .seller, .contract .signatures .buyer').show();
        $('.contract .signatures .seller > .signature-text').text(translation.contract.purchase.seller_signature);
        $('.contract .signatures .buyer > .signature-text').text(translation.contract.purchase.buyer_signature);

        if (data.data.owner) {
            $('.contract .paragraph_text_1').html((translation.contract['purchase'].paragraph_1_text).format(' ' + data.data.characterName, data.data.address));
            $('.contract .signatures .seller > #make_signature_seller').hide();
            $('.contract .signatures .buyer > #make_signature_buyer').show();
            $('.contract .paragraph_text_2').html((translation.contract['purchase'].paragraph_2_text).format(
                translation.currency,
                formatNumber(Number(data.data.price), 2, 2),
                data.data.paymentMethod == 'cash' ? translation.select_menu.payment_cash : translation.select_menu.payment_bank
            ));
            $('.contract .signatures #signature_seller').text(data.data.ownerName);
        } else {
            $('.contract .paragraph_text_1').html((translation.contract['purchase'].paragraph_1_text).format('<select id="select-player"></select><div id="select-player-refresh"><i class="fa-solid fa-arrows-rotate"></i></div>', data.data.address));
            $('.contract .signatures .seller > #make_signature_seller').show();
            $('.contract .signatures .buyer > #make_signature_buyer').hide();
            $('.contract .paragraph_text_2').html((translation.contract['purchase'].paragraph_2_text).format(
                translation.currency,
                `<input id="input-price" placeholder="0" onkeydown="return isNumberKey(event)" onpaste="return false"></input>`,
                `<select id="select-payment-method"></select>`
            ));
        }


        $.post(`https://${GetParentResourceName()}/getClosestPlayers`);

    } else if (type == 'rent') {
        $('.contract .buttons').show();
        $(`.contract .buttons > div[data-type="rent"]`).addClass('active');
        $('.contract .center#title').text(translation.contract['rent'].title);
        $('.contract .paragraph_1').text(translation.contract['rent'].paragraph_1_title);
        $('.contract .paragraph_2').text(translation.contract['rent'].paragraph_2_title);
        $('.contract .paragraph_3').text(translation.contract['rent'].paragraph_3_title);
        
        $('.contract .paragraph_text_1').html((translation.contract['rent'].paragraph_1_text).format('', data.data.address));

        $('.contract .signatures .seller').hide();

        $('.contract .signatures .buyer').show();
        $('.contract .signatures .buyer > #make_signature_buyer').show();
        $('.contract .signatures .buyer > .signature-text').text(translation.contract.rent.lessee_signature);

        $('.contract .paragraph_text_2').html((translation.contract['rent'].paragraph_2_text).format(
            `<select id="select-rent-cycle"></select>`,
            translation.currency,
            `<span id="price" data-price="${data.data.rentPrice}">-</span>`,
            '<span id="cycle-1">...</span>',
            allowedUnpaidRentBills,
            '<span id="cycle-2">...</span>',
            `<select id="select-payment-method"></select>`
        ));
    } else {
        $('.contract .buttons').show();
        $(`.contract .buttons > div[data-type="purchase"]`).addClass('active');
        $('.contract .center#title').text(translation.contract['purchase'].title);
        $('.contract .paragraph_1').text(translation.contract['purchase'].paragraph_1_title);
        $('.contract .paragraph_2').text(translation.contract['purchase'].paragraph_2_title);
        $('.contract .paragraph_3').text(translation.contract['purchase'].paragraph_3_title);

        $('.contract .paragraph_text_1').html((translation.contract['purchase'].paragraph_1_text).format('', data.data.address));

        $('.contract .signatures .seller').hide();
        
        $('.contract .signatures .buyer').show();
        $('.contract .signatures .buyer > #make_signature_buyer').show();
        $('.contract .signatures .buyer > .signature-text').text(translation.contract.purchase.buyer_signature);

        $('.contract .paragraph_text_2').html((translation.contract['purchase'].paragraph_2_text).format(
            translation.currency,
            formatNumber(data.data.purchasePrice, 0, 0),
            `<select id="select-payment-method"></select>`
        ));
    }

    if (!data.data.owner) {
        let rentCyclesOptions = [
            {
                id: 0,
                text: translation.select_menu.select_option,
                disabled: true,
                selected: true
            },
        ]

        if (rentalCycles['weekly']) {
            rentCyclesOptions.push(
                {
                    id: 'weekly',
                    text: translation.select_menu.rent_weekly
                }
            )
        }
        
        if (rentalCycles['monthly']) {
            rentCyclesOptions.push(
                {
                    id: 'monthly',
                    text: translation.select_menu.rent_monthly
                }
            )
        }

        $('.contract .paragraph_text_2 > select#select-rent-cycle').select2({
            minimumResultsForSearch: Infinity,
            allowClear: false,
            data: rentCyclesOptions
        });
        
        $('.contract .paragraph_text_2 > select#select-payment-method').select2({
            minimumResultsForSearch: Infinity,
            allowClear: false,
            data: [
                {
                    id: 0,
                    text: translation.select_menu.select_option,
                    disabled: true,
                    selected: true
                },
                {
                    id: 'cash',
                    text: translation.select_menu.payment_cash
                },
                {
                    id: 'bank',
                    text: translation.select_menu.payment_bank
                }
            ]
        });
    }

    $('.contract .paragraph_3, .contract .paragraph_text_3').hide();
    if (data.data.electricity || data.data.internet || data.data.water) {
        let billsHTML = '';
        if (data.data.electricity && data.data.electricity.rate) {
            billsHTML += `<br><i class="fa-solid fa-plug-circle-bolt"></i> ${(translation.contract.electricity_bill).format(translation.currency, formatNumber(data.data.electricity.rate, 2, 5), `/${data.data.electricity.unit}`)}`
        }
        if (data.data.water && data.data.water.rate) {
            billsHTML += `<br><i class="fa-solid fa-shower"></i> ${(translation.contract.water_bill).format(translation.currency, formatNumber(data.data.water.rate, 2, 5), `/${data.data.water.unit}`)}`
        }
        if (data.data.internet && data.data.internet.flatRate) {
            billsHTML += `<br><i class="fa-solid fa-wifi"></i> ${(translation.contract.internet_bill).format(translation.currency, formatNumber(data.data.internet.flatRate, 2, 5))}`
        }
        
        if (type == 'rent-out' || type == 'rent') {
            $('.contract .paragraph_text_3').html((translation.contract['rent'].paragraph_3_text).format(billsHTML)).show();
        } else {
            $('.contract .paragraph_text_3').html((translation.contract['purchase'].paragraph_3_text).format(billsHTML)).show();
        }

        $('.contract .paragraph_3').show();
    }
}

$(document).on('change', '#select-rent-cycle', function () {
    const selected = $(this).select2('data')[0];
    const selectedVal = selected.id;
    
    $('.contract .paragraph_text_2 span#cycle-1').html(selectedVal == 'weekly' ? translation['time.week'] : translation['time.month']);
    $('.contract .paragraph_text_2 span#cycle-2').html(selectedVal == 'weekly' ? translation['time.weeks'] : translation['time.months']);
    
    let priceElement = $('.contract .paragraph_text_2 span#price');
    let price = priceElement.data('price');
    priceElement.html(selectedVal == 'weekly' ? formatNumber(Math.floor((price * 12) / (365.25 / 7)), 2, 2) : formatNumber(price, 2, 2));
});

$(document).on('click', '.contract #make_signature_seller', function (e) {
    let player = $('.contract select#select-player').select2('data')[0];
    let price = $('.contract input#input-price').val();

    let paymentMethodSelect = $('.contract select#select-payment-method');
    let paymentMethod = paymentMethodSelect.select2('data')[0];

    let rentCycleSelect = contractType != 'transfer' && $('.contract select#select-rent-cycle');
    let rentCycle = rentCycleSelect ? rentCycleSelect.select2('data')[0] : null;

    $(".contract .paragraph_text_2 .select2-container .select2-selection, .contract .paragraph_text_2 input").removeClass("required");

    let allowContinue = true;
    if (!player || player.id == 0) {
        $(".contract .paragraph_text_1 .select2-container .select2-selection").addClass("required");
        allowContinue = false;
    }
    
    if (!price || price <= 0) {
        $(".contract .paragraph_text_2 input#input-price").addClass("required");
        allowContinue = false;
    }
    
    if (rentCycleSelect && (!rentCycle || rentCycle.id == 0)) {
        const $container = rentCycleSelect.next('.select2-container');
        $container.find('.select2-selection').addClass('required');
        allowContinue = false;
    }

    if (!paymentMethod || paymentMethod.id == 0) {
        const $container = paymentMethodSelect.next('.select2-container');
        $container.find('.select2-selection').addClass('required');
        allowContinue = false;
    }
    
    if (!allowContinue) return;

    let $btn = $(this);
    
    if ($btn.data("writing")) return;
    $btn.data("writing", true);
    $btn.hide();
    
    let signature = characterName;
    let signatureElement = document.getElementById('signature_seller');
    let currentLetterIndex = 0;
    let buffer = "";

    function stopLetter() {
        $.post(`https://${GetParentResourceName()}/propertyContract:send`, JSON.stringify({
            player: player.id,
            price: price,
            paymentMethod: paymentMethod.id,
            rentCycle: rentCycleSelect && rentCycle.id,
            contractType: contractType,
        }));
        setTimeout(() => {
            currentMenu = null;
            contractType = null;
            $btn.data("writing", false);
        }, 1000);
    }

    function addNextLetter() {
        buffer += signature[currentLetterIndex];
        signatureElement.textContent = buffer;
        
        currentLetterIndex++;
        if (currentLetterIndex < signature.length) {
            setTimeout(addNextLetter, 100);
        } else {
            stopLetter();
        }
    }

    addNextLetter();
});

$(document).on('click', '.contract #make_signature_buyer', function (e) {
    let allowContinue = true;

    let paymentMethodSelect = contractType != 'rent-out' && contractType != 'transfer' && $('.contract select#select-payment-method');
    let paymentMethod = paymentMethodSelect ? paymentMethodSelect.select2('data')[0] : null;

    let rentCycleSelect = contractType == 'rent' && $('.contract select#select-rent-cycle');
    let rentCycle = rentCycleSelect ? rentCycleSelect.select2('data')[0] : null;

    if (contractType != 'rent-out' && contractType != 'transfer') {
        if (rentCycleSelect && (!rentCycle || rentCycle.id == 0)) {
            const $container = rentCycleSelect.next('.select2-container');
            $container.find('.select2-selection').addClass('required');
            allowContinue = false;
        }
        if (!paymentMethod || paymentMethod.id == 0) {
            const $container = paymentMethodSelect.next('.select2-container');
            $container.find('.select2-selection').addClass('required');
            allowContinue = false;
        }
    }
    
    if (!allowContinue) return;

    let $btn = $(this);
    
    if ($btn.data("writing")) return;
    $btn.data("writing", true);
    $btn.hide();
    
    let signature = characterName;
    let signatureElement = document.getElementById('signature_buyer');
    let currentLetterIndex = 0;
    let buffer = "";

    function stopLetter() {
        if (contractType != 'rent-out' && contractType != 'transfer') {
            $.post(`https://${GetParentResourceName()}/propertyOffer:contractDone`, JSON.stringify({
                paymentMethod: paymentMethod.id,
                rentCycle: rentCycleSelect && rentCycle.id,
                contractType: contractType,
                apartmentId: Property.SelectedApartmentId,
                selectedTheme: Property.SelectedTheme
            }));
        } else {
            $.post(`https://${GetParentResourceName()}/propertyContract:signed`);
        }
        setTimeout(() => {
            currentMenu = null;
            contractType = null;
            $btn.data("writing", false);
        }, 1000);
    }

    function addNextLetter() {
        buffer += signature[currentLetterIndex];
        signatureElement.textContent = buffer;
        
        currentLetterIndex++;
        if (currentLetterIndex < signature.length) {
            setTimeout(addNextLetter, 100);
        } else {
            stopLetter();
        }
    }

    addNextLetter();
});

$(document).on('click', '.housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-info > div.your-orders', function(e) {
    updateSection('.housing_manage', 'orders-list');
})

$(document).on('click', '.housing_manage div[data-type="furniture"] > div > .side-boxes > .box > .furniture-info > div.ikea', function(e) {
    updateSection('.housing_manage', 'order-furniture', '.housing_manage li[data-href="order-furniture"]');
})

$(document).on('click', '.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box .images > .informations > .images-list #add-image', function(e) {
    let imageId = $(this).data('image-id');
    Property.ShowModal(
        (translation.manage.marketplace['image:modal']['title']).format(imageId),
        undefined,
        `
            <input id="image-url" class="full-width" placeholder="${translation.manage.marketplace['image:modal']['input.placeholder']}"/>
        `,
        `
            <div id="accept" data-type="make-photo" data-image-id="${imageId}">${translation.manage.marketplace['image:modal']['btn.screenshot']}</div>
            <div id="accept" data-type="save-photo" data-image-id="${imageId}">${translation.manage.marketplace['image:modal']['btn.sell']}</div>
            ${Property.ManageData?.images?.[String(imageId)] ? `<div id="accept" data-type="remove-photo" data-image-id="${imageId}">${translation.manage.marketplace['image:modal']['btn.remove']}</div>` : ''}
            <div id="cancel">${translation['button.cancel']}</div>
        `
    )
})

$(document).on('click', '.housing_manage .menu ul > li', function(e) {
    let newMenu = $(this).data('href');
    
    if (newMenu == 'rent-out') {
        reloadContract('rent-out', {
            data: {
                address: Property.ManageData.address,
                electricity: Property.ManageData.electricity,
                internet: Property.ManageData.internet,
                water: Property.ManageData.water,
            },
        })
        $('.housing_manage').fadeOut(120);
        $('.contract').fadeIn(150);
        
    } else if (newMenu == 'transfer') {
        reloadContract('transfer', {
            data: {
                address: Property.ManageData.address,
                electricity: Property.ManageData.electricity,
                internet: Property.ManageData.internet,
                water: Property.ManageData.water,
            },
        })
        $('.housing_manage').fadeOut(120);
        $('.contract').fadeIn(150);

    } else if (newMenu == 'check-cameras') {
        return $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify({action:'check-cameras'}));

    } else if (newMenu == 'check-cameras-inside') {
        return $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify({action:'check-cameras', environment:'inside'}));
        
    } else if (newMenu == 'check-cameras-outside') {
        return $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify({action:'check-cameras', environment:'outside'}));

    } else if (newMenu == 'change-wardrobe-position') {
        return $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify({action:'change-wardrobe-position'}));
        
    } else if (newMenu == 'change-storage-position') {
        return $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify({action:'change-storage-position'}));
        
    } else if (newMenu == 'sell') {
        return Property.ShowModal(
            translation.manage['sell_property:modal']['title'],
            (translation.manage['sell_property:modal']['description']).format(translation.currency, formatNumber(Property.ManageData.autoSellPrice, 0, 0)),
            undefined,
            `
                <div id="accept" data-type="marketplace-sell">${translation.manage['sell_property:modal']['btn.sell']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `
        );
    } else if (newMenu == 'move_out') {
        return Property.ShowModal(
            translation.manage['move_out:modal']['title'],
            translation.manage['move_out:modal']['description'],
            undefined,
            `
                <div id="accept" data-type="move-out">${translation.manage['move_out:modal']['btn.move_out']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `
        );
    } else {
        if (newMenu == 'marketplace' && Property.ManageData.renter) {
            return $.post(`https://${GetParentResourceName()}/sendNotification`, JSON.stringify({name: 'notify.property:marketplace_blocked_by_renter', type: 'info'}));
        }

        updateSection('.housing_manage', newMenu, this);
    }
})

$(document).on('click', '.housing_manage>div>.menu>#order-furniture-menu', function(e) {
    if (!$(e.target).closest('#order-furniture-menu > div').length) {
        $('.housing_manage>div>.menu>#order-furniture-menu').fadeOut(120);
        setTimeout(() => {
            $(`
                .housing_manage>div>.menu>#order-furniture-menu>div>.data>.image,
                .housing_manage>div>.menu>#order-furniture-menu>div>.data>.informations,
                .housing_manage>div>.menu>#order-furniture-menu>div>.buttons
            `).empty();
        }, 150);
    }
})

const filterFurniture = function() {
    let searchValue = $('.housing_manage div[data-type="order-furniture"] #search input').val().toLowerCase();
    let selectedTag = $('.housing_manage div[data-type="order-furniture"] select[name="furniture-tag"]').val();
    let selectedEnvironment = $('.housing_manage div[data-type="order-furniture"] select[name="furniture-environment"]').val();

    $('.housing_manage div[data-type="order-furniture"] .furniture-list > div').each(function () {
        let name = $(this).find('.name').text().toLowerCase();
        let tag = $(this).data('tag')?.toString();
        let isInside = $(this).data('is-inside')?.toString();
        let isOutside = $(this).data('is-outside')?.toString();

        let matchSearch = name.includes(searchValue);
        let matchTag = !selectedTag || selectedTag === "0" || tag === selectedTag;
        let matchEnvironment = !selectedEnvironment || selectedEnvironment === "0" || (selectedEnvironment === 'inside' && isInside === "1" || selectedEnvironment === 'outside' && isOutside === "1");

        $(this).toggle(matchSearch && matchTag && matchEnvironment);
    });
};
$('.housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-filters > #search > input').on('keyup', filterFurniture)
$('.housing_manage div[data-type="order-furniture"] select[name="furniture-tag"]').on('select2:select', filterFurniture)
$('.housing_manage div[data-type="order-furniture"] select[name="furniture-environment"]').on('select2:select', filterFurniture)

$(document).on('click', '.housing_manage div[data-type="my-house"]>div>.side-boxes>.box>.options>.alerts>.alert>.remove', function() {
    $(this).closest('.alert').fadeOut(200, function() {
        $(this).remove();
    });
});

$(document).on('click', '.housing_manage div.clickable-btn', function(e) {
    let action = $(this).data('action');

    if ($(this).hasClass('not-allowed')) return;
    
    let jsonData = {
        action: action,
    }

    if (action == 'take-to-storage') {
        jsonData.furnitureId = $(this).data('furniture-id');

    } else if (action == 'sell-furniture') {
        let furnitureId = $(this).data('furniture-id');
        let model = $(this).data('model');

        let sellPrice = 0
        if (Property.FurnitureList[model].price && Property.FurnitureList[model].price >= 1 && furnitureSellPercentage >= 1) {
            sellPrice = Math.floor(Property.FurnitureList[model].price * (furnitureSellPercentage / 100))
        }

        return Property.ShowModal(
            translation.manage.furniture['sell_furniture:modal']['title'],
            (translation.manage.furniture['sell_furniture:modal']['description']).format(Property.FurnitureList[model] && Property.FurnitureList[model].label || model, translation.currency, formatNumber(sellPrice, 0, 0)),            
            (Property.FurnitureList[model].interactableName === 'storage' || Property.FurnitureList[model].interactableName === 'safe') && `
                <div class="info-panel">
                    <div class="title">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span>${translation.manage.furniture['sell_furniture:modal']['info.title']}</span>
                    </div>
                    <div class="description">${translation.manage.furniture['sell_furniture:modal']['info.description']}</div>
                </div>
            ` || '',
            `
                <div id="accept" data-type="sell-furniture" data-furniture-id="${furnitureId}" data-model="${model}">${translation.manage.furniture['sell_furniture:modal']['btn.sell']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `
        );

    } else if (action == 'remove-furniture') {
        let furnitureId = $(this).data('furniture-id');
        let model = $(this).data('model');
        return Property.ShowModal(
            translation.manage.furniture['remove_furniture:modal']['title'],
            (translation.manage.furniture['remove_furniture:modal']['description']).format(Property.FurnitureList[model] && Property.FurnitureList[model].label || model),
            (Property.FurnitureList[model].interactableName === 'storage' || Property.FurnitureList[model].interactableName === 'safe') && `
                <div class="info-panel">
                    <div class="title">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span>${translation.manage.furniture['remove_furniture:modal']['info.title']}</span>
                    </div>
                    <div class="description">${translation.manage.furniture['remove_furniture:modal']['info.description']}</div>
                </div>
            ` || '',
            `
                <div id="accept" data-type="remove-furniture" data-furniture-id="${furnitureId}" data-model="${model}">${translation.manage.furniture['remove_furniture:modal']['btn.remove']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `
        );
        
    } else if (action == 'order-furniture') {
        let model = $(this).data('model');
        let furnitureData = Property.FurnitureList[model];
        if (furnitureData) {
            $('.housing_manage>div>.menu>#order-furniture-menu>div>.data>.image').html(`<img src="./images/furniture/${model}.webp" draggable="false">`)

            let deliveryCharge = furnitureData.deliveryCharge || Property.ManageData.deliveries[furnitureData.deliverySize].defaultDeliveryCharge

            let informationsHTML = '';
            informationsHTML += `<div>${translation.manage.order['checkout:modal']['description:section.informations']}</div>`
            informationsHTML += `<span class="name"><i class="fa-solid fa-tag"></i> ${translation.manage.order['checkout:modal']['description.product']} <span>${furnitureData.label || model}</span></span>`
            informationsHTML += `<span class="price"><i class="fa-solid fa-sack-dollar"></i> ${translation.manage.order['checkout:modal']['description.price']} <span>${translation.currency}${formatNumber(furnitureData.price, 2, 2)}</span></span>`
            if (deliveryFurnitureType != 1) {
                informationsHTML += `<span class="delivery-charge"><i class="fa-solid fa-truck"></i> ${translation.manage.order['checkout:modal']['description.delivery_charge']} <span>${translation.currency}${formatNumber(deliveryCharge, 2, 2)}</span></span>`
                informationsHTML += `<span class="delivery-time"><i class="fa-solid fa-clock"></i> ${translation.manage.order['checkout:modal']['description.delivery_time']} <span>${furnitureData.deliveryTime ? formatDeliveryTime(furnitureData.deliveryTime) : formatDeliveryTime(Property.ManageData.deliveries[Number(furnitureData.deliverySize)].defaultDeliveryTime)}</span></span>`
            }

            if (furnitureData.interactableName) {
                informationsHTML += `<div class="interactable-info">${translation.manage.order['checkout:modal']['description:section.interactable']}</div>`
                if (config.interactableInfo[furnitureData.interactableName]) {
                    informationsHTML += `<span>${translation.manage.order['checkout:modal']['description.type']} <span>${config.interactableInfo[furnitureData.interactableName].label}</span></span>`
                    if (furnitureData.metadata) {
                        for (const [metadataName, metadataValue] of Object.entries(furnitureData.metadata)) {
                            if (metadataName == 'weight') {
                                informationsHTML += `<span>${config.interactableInfo[furnitureData.interactableName][metadataName]}: <span>${metadataValue / 1000} ${translation['weight.kg']}</span></span>`
                            } else {
                                informationsHTML += `<span>${config.interactableInfo[furnitureData.interactableName][metadataName]}: <span>${metadataValue}</span></span>`
                            }
                        }
                    }
                    if (config.interactableInfo[furnitureData.interactableName].description) {
                        informationsHTML += `<span>${translation.manage.order['checkout:modal']['description.description']} <span>${config.interactableInfo[furnitureData.interactableName].description}</span></span>`
                    }
                }
            }

            $('.housing_manage>div>.menu>#order-furniture-menu>div>.data>.informations').html(informationsHTML)

            $('.housing_manage>div>.menu>#order-furniture-menu>div>.buttons').html(`
                <div class="clickable-btn button" data-action="checkout-furniture" data-payment="bank" data-model="${model}">${(translation.manage.order['checkout:modal']['btn.pay']).format(translation.currency, formatNumber(Number(furnitureData.price) + Number(deliveryCharge), 0, 2))}</div>
                <div class="clickable-btn button" data-action="checkout-furniture">${translation['button.cancel']}</div>
            `)

            $('.housing_manage>div>.menu>#order-furniture-menu').fadeIn(120);
        }
        return;
    } else if (action == 'checkout-furniture') {
        let payment = $(this).data('payment');
        let model = $(this).data('model');

        jsonData.payment = payment;
        jsonData.model = model;

        if (!payment) {
            $('.housing_manage>div>.menu>#order-furniture-menu').fadeOut(120);
            setTimeout(() => {
                $(`
                    .housing_manage>div>.menu>#order-furniture-menu>div>.data>.image,
                    .housing_manage>div>.menu>#order-furniture-menu>div>.data>.informations,
                    .housing_manage>div>.menu>#order-furniture-menu>div>.buttons
                `).empty();
            }, 150);
            return;
        }
    } else if (action == 'purchase-upgrade') {
        jsonData.name = $(this).data('name');
    } else if (action == 'marketplace-add') {
        jsonData.description = $('.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box > .options > .description > .informations > textarea').val();

        jsonData.furnished = $('.inp-cbx[data-toggle="manage-furnished"]').prop('checked');

        jsonData.contact_number = $('.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box > .options > .contact-number > .informations > input').val();

        jsonData.sale = $('.inp-cbx[data-toggle="manage-purchase-price"]').prop('checked');
        jsonData.salePrice = $('.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box > .options > .sale > .informations > input').val();

        jsonData.rental = $('.inp-cbx[data-toggle="manage-rental-price"]').prop('checked');
        jsonData.rentalPrice = $('.housing_manage div[data-type="marketplace"] > div > .side-boxes > .box > .options > .rental > .informations > input').val();
    } else if (action == 'rental-details') {
        return Property.ShowModal(
            translation.manage.main['rental:modal']['title'],
            `
                ${translation.manage.main['rental:modal']['description.renter']} ${Property.ManageData.renterName}<br>
                ${translation.manage.main['rental:modal']['description.rent_start']} ${formatDate(Property.ManageData.rental.startTime).date}
            `,
            undefined,
            `
                <div id="accept" data-type="rental-terminate-now">${translation.manage.main['rental:modal']['btn.terminate_now']}</div>
                ${Property.ManageData.rental.terminateAtPeriod ? `<div id="accept" data-type="rental-cancel-termination">${translation.manage.main['rental:modal']['btn.cancel_termination']}</div>` : `<div id="accept" data-type="rental-termination">${translation.manage.main['rental:modal']['btn.termination']}</div>`}
                <div id="cancel">${translation['button.close']}</div>
            `
        );
    } else if (action == 'remove-permission') {
        jsonData.identifier = $(this).data('identifier');

    } else if (action == 'manage-permission') {
        let identifier = $(this).data('identifier');
        let permissions = Property.ManageData.permissions?.[identifier]
        if (!permissions) return;
        
        return Property.ShowModal(
            (translation.manage.permissions['manage_permissions:modal']['title']).format(permissions._name),
            undefined,
            `
                ${renderPermissionCheckbox('garage', translation.manage.permissions['manage_permissions:modal']['perm.garage'], permissions["garage"])}
                ${renderPermissionCheckbox('furniture', translation.manage.permissions['manage_permissions:modal']['perm.furniture'], permissions["furniture"])}
                ${renderPermissionCheckbox('billPayments', translation.manage.permissions['manage_permissions:modal']['perm.bill_payments'], permissions["billPayments"])}
                ${renderPermissionCheckbox('keysManage', translation.manage.permissions['manage_permissions:modal']['perm.keys_manage'], permissions["keysManage"])}
                ${renderPermissionCheckbox('upgradesManage', translation.manage.permissions['manage_permissions:modal']['perm.upgrades_manage'], permissions["upgradesManage"])}
                ${renderPermissionCheckbox('marketplaceManage', translation.manage.permissions['manage_permissions:modal']['perm.marketplace_manage'], permissions["marketplaceManage"], true)}
                ${renderPermissionCheckbox('sell', translation.manage.permissions['manage_permissions:modal']['perm.sell'], permissions["sell"], true)}
                ${renderPermissionCheckbox('automaticSell', translation.manage.permissions['manage_permissions:modal']['perm.automatic_sell'], permissions["automaticSell"], true)}
                ${renderPermissionCheckbox('rent', translation.manage.permissions['manage_permissions:modal']['perm.rent'], permissions["rent"], true)}
                ${renderPermissionCheckbox('rentersManage', translation.manage.permissions['manage_permissions:modal']['perm.renters_manage'], permissions["rentersManage"], true)}
            `,
            `
                <div id="accept" data-type="save-permission" data-identifier="${identifier}">${translation['button.save']}</div>
                <div id="cancel">${translation['button.close']}</div>
            `
        );
    } else if (action == 'create-permission') {
        Property.ShowModal(
            translation.manage.permissions['add_permissions:modal']['title'],
            undefined,
            `
                <select id="select-player"></select>
            `,
            `
                <div id="accept" data-type="add-player-permission">${translation.manage.permissions['add_permissions:modal']['button.add']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `
        );

        $.post(`https://${GetParentResourceName()}/getClosestPlayers`);
        
        return;
    } else if (action == 'give-key') {
        Property.ShowModal(
            translation.manage.keys['give_key:modal']['title'],
            undefined,
            `
                <select id="select-player"></select>
            `,
            `
                <div id="accept" data-type="give-key">${translation.manage.keys['give_key:modal']['btn.give_key']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `
        );

        $.post(`https://${GetParentResourceName()}/getClosestPlayers`);
        
        return;
    } else if (action == 'remove-key') {
        jsonData.identifier = $(this).data('identifier');
    }

    $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify(jsonData));
})

$(document).on('click', '.property_offer > div > .menu > .main > .apartments-list .button', function(e) {
    let apartmentId = $(this).data('apartment-id');
    if (!apartmentId) return;

    $.post(`https://${GetParentResourceName()}/apartments:getInformations`, JSON.stringify({
        apartmentId: apartmentId,
    }));
})

$(document).on('click', '.property_offer > div > .menu > .main > .apartments-actions > div', function(e) {
    let apartmentId = $(this).data('apartment-id');
    let apartmentAction = $(this).data('apartment-action');
    if (!apartmentId || !apartmentAction) return;

    $.post(`https://${GetParentResourceName()}/apartments:action`, JSON.stringify({
        apartmentId: apartmentId,
        action: apartmentAction,
    }));
})

$(document).on('click', '.housing_manage .inp-cbx', function() {
    let isChecked = $(this).prop('checked');
    if ($(this).hasClass('not-allowed')) {
        $(this).prop('checked', !isChecked);
        return
    };

})

$(document).on('click', '.housing_manage #modal', function(event) {
    if (event.target === this) {
        $('.housing_manage>div>.menu>#modal').fadeOut(120);
        setTimeout(() => {
            $(`.housing_manage #modal #header > #title, .housing_manage #modal #description, .housing_manage #modal #description-actions, .housing_manage #modal #buttons`).empty();
        }, 150);
    }
});

$(document).on('click', '.housing_manage #modal #header > #close, .housing_manage #modal #buttons > #cancel', function(event) {
    $('.housing_manage>div>.menu>#modal').fadeOut(120);
    setTimeout(() => {
        $(`.housing_manage #modal #header > #title, .housing_manage #modal #description, .housing_manage #modal #description-actions, .housing_manage #modal #buttons`).empty();
    }, 150);
});

$(document).on('click', '.housing_manage #modal #buttons > #accept', function() {
    const type = $(this).data('type');

    let jsonData = {
        action: "modal-accepted",
        type: type,
    }

    if (type == 'pay-bill') {
        jsonData.period = $(this).data('period');
        jsonData.billType = $(this).data('bill-type');
        
    } else if (type == 'make-photo') {
        jsonData.imageId = $(this).data('image-id');
        
    } else if (type == 'save-photo') {
        jsonData.imageUrl = $('.housing_manage>div>.menu>#modal>div>#description-actions input#image-url').val();
        jsonData.imageId = $(this).data('image-id');
        
    } else if (type == 'remove-photo') {
        jsonData.imageId = $(this).data('image-id');

    } else if (type == 'save-permission') {
        jsonData.identifier = $(this).data('identifier');

        jsonData.garage = getPermissionCheckboxState('garage');
        jsonData.furniture = getPermissionCheckboxState('furniture');
        jsonData.billPayments = getPermissionCheckboxState('billPayments');
        jsonData.keysManage = getPermissionCheckboxState('keysManage');
        jsonData.upgradesManage = getPermissionCheckboxState('upgradesManage');
        jsonData.marketplaceManage = getPermissionCheckboxState('marketplaceManage');
        jsonData.sell = getPermissionCheckboxState('sell');
        jsonData.automaticSell = getPermissionCheckboxState('automaticSell');
        jsonData.rent = getPermissionCheckboxState('rent');
        jsonData.rentersManage = getPermissionCheckboxState('rentersManage');

    } else if (type == 'add-player-permission' || type == 'give-key') {
        let player = $('.housing_manage>div>.menu>#modal>div>#description-actions>select#select-player').select2('data')[0];
        if (!player || player.id == 0) return;
        jsonData.id = player.id
        
    } else if (type == 'sell-furniture') {
        jsonData.furnitureId = $(this).data('furniture-id');
        jsonData.model = $(this).data('model');
        
    } else if (type == 'remove-furniture') {
        jsonData.furnitureId = $(this).data('furniture-id');
        jsonData.model = $(this).data('model');

    }

    $.post(`https://${GetParentResourceName()}/propertyManageAction`, JSON.stringify(jsonData));
})

$(document).on('click', '.contract .paragraph_text_1 #select-player-refresh', function() {
    $.post(`https://${GetParentResourceName()}/getClosestPlayers`);
})


$(document).on('click', '.housing_manage div[data-type="bills"] > div > .side-boxes > .box > .bills-list > table > tbody .view-details', function() {
    const period = $(this).data('period');
    const type = $(this).data('type');
    
    let bill = null;
    for (const [id, element] of Object.entries(Property.ManageData['bills'])) {
        if (element.period == period && element.type == type) {
            bill = element;
            break
        }
    }

    const details = JSON.parse(bill.details);

    if (type == 'rent') {
        Property.ShowModal((translation.manage.bills['modal:rent.header']).format(formatPeriod(period)), `
            ${(translation.manage.bills['modal:rent.description']).format(translation.currency, formatNumber(details.rent, 2, 2))}<br>
        `, undefined, `
            ${bill.paid == 1 ? `
                <div id="cancel">${translation['button.close']}</div>
            ` : `
                <div id="accept" data-type="pay-bill" data-period="${period}" data-bill-type="rent">${translation.manage.bills['modal:button.pay_for_rent']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `}
        `)
    } else if (type == 'services') {
        const electricityTime = details.electricityUsage || 0;
        const electricityCost = details.electricity || 0;
        const waterUsage = details.waterUsage || 0;
        const waterCost = details.water || 0;
        const internetCost = details.internet || 0;
    
        const electricityRate = details.rateInfo?.electricity || 0;
        const waterRate = details.rateInfo?.water || 0;

        Property.ShowModal((translation.manage.bills['modal:bill.header']).format(formatPeriod(period)), `
            <b style="font-size: 1.15em;opacity: 0.7;"><i class="fa-solid fa-plug-circle-bolt" style="margin-right: 0.4em;"></i>${translation.manage.bills['card_electricity:label']}</b><br>
            ${translation.manage.bills['bill.consumption']} ${electricityTime.toLocaleString()} ${translation['time.seconds']}<br>
            ${translation.manage.bills['bill.rate']} ${translation.currency} ${electricityRate.toFixed(2)}/${translation['time.seconds']}<br>
            ${translation.manage.bills['bill.cost']} ${translation.currency} ${electricityCost.toFixed(2)}<br>
            <br>
            <b style="font-size: 1.15em;opacity: 0.7;"><i class="fa-solid fa-shower" style="margin-right: 0.4em;"></i>${translation.manage.bills['card_water:label']}</b><br>
            ${translation.manage.bills['bill.consumption']} ${waterUsage.toLocaleString()} ${translation['volume:liters']}<br>
            ${translation.manage.bills['bill.rate']} ${translation.currency} ${waterRate.toFixed(2)}/${translation['volume:liters']}<br>
            ${translation.manage.bills['bill.cost']} ${translation.currency} ${waterCost.toFixed(2)}<br>
            <br>
            <b style="font-size: 1.15em;opacity: 0.7;"><i class="fa-solid fa-wifi" style="margin-right: 0.4em;"></i>${translation.manage.bills['card_internet:label']}</b><br>
            ${translation.manage.bills['bill.cost']} ${translation.currency} ${internetCost.toFixed(2)}
            <br>
            <br>
            <b style="font-size: 1.25em;">${translation.manage.bills['bill.total']} ${translation.currency} ${formatNumber(electricityCost + waterCost + internetCost, 2, 2)}</b>
        `, undefined, `
            ${(bill.paid == 1 || period === getCurrentPeriod()) ? `
                <div id="cancel">${translation['button.close']}</div>
            ` : `
                <div id="accept" data-type="pay-bill" data-period="${period}" data-bill-type="services">${translation.manage.bills['modal:button.pay_the_bill']}</div>
                <div id="cancel">${translation['button.cancel']}</div>
            `}
        `)
    }
})