// UI Variables:
let translation = {};
let canUseAgain = true;
let currentMenu = null;
let currentSubMenu = null;
let selectedOption = null;
let selectedSection = null
let webhook = null

// General:
let characterName = null;
let areaUnit = "m2";
let allowedUnpaidBills = null;
let allowedUnpaidRentBills = null;
let keysOnItem = false;
let keysLimit = 0;
let keyPrice = 0;
let lockReplacementPrice = 0;
let furnitureSellPercentage = 0;
let requirePurchaseFurniture = false;
let deliveryFurnitureType = null;
let allowChangeStoragePosition = null;
let allowChangeWardrobePosition = null;
let allowTransactionFromMenu = null;
let usingVMSGarages = false;
let useServiceBills = false;
let rentalCycles = []

// Contract Variables:
let contractType = null;

window.addEventListener("load", function () {
    $.post(`https://${GetParentResourceName()}/loaded`)
})

window.addEventListener('message', function (event) {
    var item = event.data;
    switch (item.action) {
        case 'loaded':
            let lang = item.lang;

            areaUnit = item.areaUnit;
            keysOnItem = item.keysOnItem;
            keysLimit = item.keysLimit;
            keyPrice = item.keyPrice;
            lockReplacementPrice = item.lockReplacementPrice;
            
            furnitureSellPercentage = item.furnitureSellPercentage;
            requirePurchaseFurniture = item.requirePurchaseFurniture;
            deliveryFurnitureType = item.deliveryFurnitureType;

            allowedUnpaidBills = item.allowedUnpaidBills;
            allowedUnpaidRentBills = item.allowedUnpaidRentBills;

            rentalCycles = item.rentalCycles;

            allowChangeStoragePosition = item.allowChangeStoragePosition;
            allowChangeWardrobePosition = item.allowChangeWardrobePosition;

            allowTransactionFromMenu = item.allowTransactionFromMenu;

            useServiceBills = item.useServiceBills;

            usingVMSGarages = item.usingVMSGarages;
            
            if (!usingVMSGarages) {
                $('.housing_creator .box > .options .parking-checkbox').hide();
                $('.housing_creator div[data-type="configuration-building"] .side-boxes .box > .options .underground_parking').hide();
                $('.housing_creator div[data-type="configuration-building"] .side-boxes .box > .options .enter_garage_point').hide();
            }

            if (!keysOnItem) {
                $('.housing_manage div[data-type="keys"] > div > .side-boxes > .box > .keys-info').css('grid-template-columns', `repeat(1, 1fr)`);
            }

            $.ajax({
                url: '../config/translation.json',
                type: 'GET',
                dataType: 'json',
                success: function (code, statut) {
                    if (!code[lang]) {
                        translation = code["EN"];
                        console.warn(`^7Selected language ^1"${lang}"^7 not found, changed to ^2"EN"^7, configure your language in translation.json.`);
                    } else {
                        translation = code[lang];
                    }
                    
                    loadTranslation();
                    
                    HousingCreator.LoadMenusData({ type: 'load-shells', AvailableShells: item.availableShells });
                    HousingCreator.LoadMenusData({ type: 'load-ipls', AvailableIPLS: item.availableIPLS });

                    let furnitureFiltersTag = [
                        {id: 0, text: translation.manage.order['filters:tag']['all'], selected: true}
                    ];
                    let furnitureTagsHTML = '';
                    let creatorFurnitureTagsHTML = '';
                    for (const [name, label] of Object.entries(config.furnitureTags)) {
                        furnitureFiltersTag.push({ id: name, text: label });
                        
                        furnitureTagsHTML += `
                            <div data-tag="${name}">
                                <div class="label">
                                    <img src="./images/categories/${name}.png" draggable="false">
                                    <p class="name">${label}</p>
                                </div>
                            </div>
                        `

                        if (name != 'theme') creatorFurnitureTagsHTML += `<div data-tag="${name}">${label}</div>`;
                    }
                    $('.housing_creator div[data-type="configuration-furniture"] #tags > .mt-4').html(creatorFurnitureTagsHTML);
                    $('.property_furniture>div>.menu>#categories > #elements').html(furnitureTagsHTML);

                    if (requirePurchaseFurniture) {
                        $('.housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-filters > select[name="furniture-tag"]').select2({
                            allowClear: false,
                            data: furnitureFiltersTag
                        });
                        
                        $('.housing_manage div[data-type="order-furniture"] > div > .side-boxes > .box > .furniture-filters > select[name="furniture-environment"]').select2({
                            allowClear: false,
                            data: [
                                {id: 0, text: translation.manage.order['filters:environment']['all'], selected: true},
                                {id: 'inside', text: translation.manage.order['filters:environment']['inside'], selected: false},
                                {id: 'outside', text: translation.manage.order['filters:environment']['outside'], selected: false}
                            ]
                        });
                    } else {
                        $('.housing_manage div[data-type="order-furniture"], .housing_manage .side-bar li.element[data-href="order-furniture"]').remove();
                    }

                    if (deliveryFurnitureType === 1) {
                        $('.housing_manage div[data-type="order-furniture"]>div>.side-boxes>.box>.furniture-info').remove();
                        $('.housing_manage div[data-type="order-furniture"]>div>.side-boxes>.box>.furniture-filters').css('margin-top', '0em');
                        $('.housing_manage div[data-type="order-furniture"]>div>.side-boxes>.box>.furniture-list').css('max-height', '46em');
                    }

                    if (deliveryFurnitureType === 1 || deliveryFurnitureType === 2) {
                        $(`
                            .housing_manage div[data-type="configuration-shell"] .shell-delivery,
                            .housing_manage div[data-type="configuration-ipl"] .ipl-delivery,
                            .housing_manage div[data-type="configuration-mlo"] .mlo-delivery
                        `).hide();
                    }

                    $('.housing_creator div[data-type="configuration-shell"] .side-boxes .box > .options input[name="shell-house_name"]').attr('maxlength', config.charactersLimit.name);
                    $('.housing_creator div[data-type="configuration-shell"] .side-boxes .box > .options textarea[name="shell-house_description"]').attr('maxlength', config.charactersLimit.description);
                }
            });
            
            break

        case 'loaded2':
            characterName = item.characterName;
            break

        case 'Reload':
            if (item.availableShells) {
                HousingCreator.LoadMenusData({ type: 'load-shells', AvailableShells: item.availableShells });
            }

            break

        case 'LoadWebhook':
            webhook = item.webhook;
            break

        case 'HousingCreator':
            HousingCreator[item.actionName](item);
            break;

        case 'Property':
            Property[item.actionName](item);
            break;

        case 'Marketplace':
            Marketplace[item.actionName](item);
            break;

        case 'ControlsMenu':
            if (item.doorsDistance) {
                $('.controls-menu > .controls #doors_distance_access').text(item.doorsDistance);
                return
            }
            ControlsMenu(item);
            break

        case 'Safe':
            Safe[item.actionName](item);
            break;

        case 'ProcessImage':
            removeGreenBackgroundEnhanced(item.image, (processedImage) => {
                scalePhoto(processedImage, (photoData) => {
                    sendToWebhook(photoData, item.fileName);
                })
            });
            break;

        case 'PlayAudio':
            playAudio(item.file, item.volume);
            break;
    }
});


$(document).on('keydown', 'body', function (e) {
    if (e.which == 27) {
        closeKey(true)
    }
})


function updateSection(menuClass, newMenu, _this, isEditingProperty) {
    if (newMenu == selectedSection) return;

    HousingCreator.IsModifyingExisting = false;

    if (_this != selectedOption) {
        if (selectedOption) $(selectedOption).removeClass("selected");
        selectedOption = _this
        $(selectedOption).addClass("selected");
    }

    if (menuClass == ".housing_creator" && newMenu == "all-properties") {
        HousingCreator.ClearPagination();
        $.post(`https://${GetParentResourceName()}/creator:getAllProperties`, JSON.stringify({}), function (properties) {
            HousingCreator.LoadPagination(properties);

            HousingCreator.RenderPagination('all-properties');
            HousingCreator.UpdatePagination('all-properties');

            $(`.housing_creator > div > .menu > .main > div`).hide();
            // div[data-type="${selectedSection}"]

            selectedSection = newMenu
            $(`div[data-type="${selectedSection}"]`).show();
        });

    } else if (menuClass == ".housing_creator" && newMenu == "all-furniture") {
        HousingCreator.ClearPagination();
        $.post(`https://${GetParentResourceName()}/creator:getAllFurniture`, JSON.stringify({}), function (furniture) {
            for (const [model, v] of Object.entries(furniture)) {
                v.model = model
            }

            HousingCreator.LoadPagination(furniture);

            HousingCreator.RenderPagination('all-furniture');
            HousingCreator.UpdatePagination('all-furniture');

            $(`.housing_creator > div > .menu > .main > div`).hide();
            // $(`div[data-type="${selectedSection}"]`).hide();
            selectedSection = newMenu
            $(`div[data-type="${selectedSection}"]`).show();
        });

    } else {
        // $(`${menuClass} div[data-type="${selectedSection}"]`).hide();
        $(`${menuClass} > div > .menu > .main > div`).hide();
        selectedSection = newMenu
        $(`${menuClass} div[data-type="${selectedSection}"]`).show();
    }

    if (
        menuClass == ".housing_creator" && (
            selectedSection == "new-shell" ||
            selectedSection == "new-ipl" ||
            selectedSection == "configuration-mlo" ||
            selectedSection == "configuration-building" ||
            selectedSection == "configuration-motel"
        )
    ) {
        HousingCreator.LoadMenusData({
            type: selectedSection,
            isEditingProperty: isEditingProperty
        })
    }
}

function closeKey(isESC) {
    if (isESC && $('.marketplace').hasClass('contract-opened')) {
        $('.contract').fadeOut(150);
        $('.marketplace').fadeIn(150).removeClass('contract-opened');
        contractType = null;
        return;
    }

    if (currentMenu == 'housing_manage') {
        if (contractType) {
            $('.housing_manage').fadeIn(150);
            $('.contract').fadeOut(150);
            contractType = null;
            return;
            
        } else if (isESC && $('.housing_manage > div > .menu > #modal').css('display') === 'block') {
            return Property.CloseModal();
            
        }
    }
    
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({ menu: currentMenu }));

    HousingCreator.ClearPagination();
    
    currentMenu = null;
    currentSubMenu = null;
    contractType = null;
}

function playAudio(file, volume) {
    const audio = new Audio(`./audio/${file}.ogg`);
    audio.volume = volume;
    audio.play();
}

$('.formatted-number').on('input', function () {
    let $this = $(this);
    let value = $this.val().replace(/,/g, '');

    if (!/^\d*$/.test(value)) {
        $this.val($this.data('raw') || ""); 
        return;
    }

    $this.data('raw', value);
    $this.val(Number(value).toLocaleString("en-US"));
});

$('.formatted-number').on('focus', function () {
    let $this = $(this);
    $this.val($this.data('raw') || ""); 
});

$('.formatted-number').on('blur', function () {
    let $this = $(this);
    $this.val(Number($this.data('raw') || "0").toLocaleString("en-US"));
});

function removeGreenBackgroundEnhanced(base64Image, callback) {
    const img = new Image();
    
    img.src = base64Image;

    img.onload = function () {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        canvas.width = img.width;
        canvas.height = img.height;

        ctx.drawImage(img, 0, 0);

        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const data = imageData.data;

        for (let i = 0; i < data.length; i += 4) {
            const red = data[i];
            const green = data[i + 1];
            const blue = data[i + 2];
            const alpha = data[i + 3];

            const greenDiff = green - Math.max(red, blue);

            if (green > 120 && greenDiff > 40) {
                const proximity = Math.min((greenDiff - 40) / 80, 1);

                data[i + 3] = Math.max(0, alpha * (1 - proximity));

                data[i + 1] = Math.max(0, green * (1 - proximity * 0.5));

                data[i] = red + green * 0.1 * proximity;
                data[i + 2] = blue + green * 0.1 * proximity;
            }
        }

        ctx.putImageData(imageData, 0, 0);

        const transparentImage = canvas.toDataURL('image/png');
        callback(transparentImage);
    };
}

function scalePhoto(base64Image, callback) {
    const img = new Image();
    img.src = base64Image;

    img.onload = function () {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        canvas.width = img.width;
        canvas.height = img.height;

        ctx.drawImage(img, 0, 0);

        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const data = imageData.data;

        let minX = canvas.width, minY = canvas.height, maxX = 0, maxY = 0;

        for (let i = 0; i < data.length; i += 4) {
            if (data[i + 3] > 0) {
                const x = (i / 4) % canvas.width;
                const y = Math.floor((i / 4) / canvas.width);

                minX = Math.min(minX, x);
                minY = Math.min(minY, y);
                maxX = Math.max(maxX, x);
                maxY = Math.max(maxY, y);
            }
        }

        if (minX < maxX && minY < maxY) {
            const width = maxX - minX;
            const height = maxY - minY;

            const squareSize = Math.max(width, height);

            const squareCanvas = document.createElement('canvas');
            const squareCtx = squareCanvas.getContext('2d');

            squareCanvas.width = squareSize;
            squareCanvas.height = squareSize;

            squareCtx.clearRect(0, 0, squareSize, squareSize);

            squareCtx.putImageData(ctx.getImageData(minX, minY, width, height), 
                Math.floor((squareSize - width) / 2), 
                Math.floor((squareSize - height) / 2)
            );

            const transparentImage = squareCanvas.toDataURL('image/png');
            callback(transparentImage);
        } else {
            callback(null);
        }
    };
}

function sendToWebhook(base64Image, fileName) {
    const webhookUrl = webhook;

    const byteString = atob(base64Image.split(',')[1]);
    const arrayBuffer = new ArrayBuffer(byteString.length);
    const uint8Array = new Uint8Array(arrayBuffer);

    for (let i = 0; i < byteString.length; i++) {
        uint8Array[i] = byteString.charCodeAt(i);
    }

    const blob = new Blob([uint8Array], { type: 'image/png' });
    const formData = new FormData();
    formData.append('file', blob, fileName + '.png');
    fetch(webhookUrl, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log('Screenshot uploaded:');
        if (data.attachments && Array.isArray(data.attachments) && data.attachments.length > 0) {
            console.log('URL:^2', data.attachments[0].url, '^7');
        } else {
            console.warn('^1No attachments found in response!^7');
        }
    })
    .catch(error => {
        console.error('Network error:', error);
    });
    
}