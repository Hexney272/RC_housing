const Marketplace = {
    Open: function(data) {
        let properties = '';
        for (const [k, v] of Object.entries(data.data.propertiesList)) {
            let parkingSpaces = 0;
            if (usingVMSGarages && v.building && v.building.type == 'building' && v.building.parkingSpaces) {
                for (const [floor, floorSpaces] of Object.entries(v.building.parkingSpaces)) {
                    for (const [spotId, propertyId] of Object.entries(floorSpaces)) {
                        if (propertyId == k) {
                            parkingSpaces += 1
                        }
                    }
                }
            }
            
            properties += (MarketplaceTemplate).format(
                k,
                v.image || 'https://consultix.radiantthemes.com/wp-content/themes/consultix/images/no-image-found-360x250.png',
                v.sale.active ? `<span>${(translation.marketplace.list['tag.for_sale']).format(translation.currency, formatNumber(v.sale.price, 0, 0))}</span>` : '',
                v.rental.active ? `<span>${(translation.marketplace.list['tag.for_rent']).format(translation.currency, formatNumber(v.rental.price, 0, 0))}</span>` : '',
                v.name,
                `
                    ${(usingVMSGarages && v.parking) && `
                        <div>
                            <i class="fa-solid fa-warehouse"></i>
                            <div>
                                <div class="title">${translation.marketplace.list['featured:label.parking']}</div>
                                <div class="description">${(translation.marketplace.list['featured:description.parking']).format(v.parking.length)}</div>
                            </div>
                        </div>
                    ` || (usingVMSGarages && v.building && v.building.type == 'building') && `
                        <div>
                            <i class="fa-solid fa-warehouse"></i>
                            <div>
                                <div class="title">${translation.marketplace.list['featured:label.parking_spaces']}</div>
                                <div class="description">${(translation.marketplace.list['featured:description.parking_spaces']).format(parkingSpaces)}</div>
                            </div>
                        </div>
                    ` || `
                        <div>
                            <i class="fa-solid fa-warehouse"></i>
                            <div>
                                <div class="title">${translation.marketplace.list['featured:label.garage']}</div>
                                <div class="description">${v.garage ? 'Has' : 'Do not have'}</div>
                            </div>
                        </div>
                    `}
                `,
                `
                    ${v.building ? `
                        <div>
                            <i class="fa-solid fa-hotel"></i>
                            <div>
                                <div class="title">${v.building.type == 'motel' ? translation.marketplace.list['featured:label.motel'] : translation.marketplace.list['featured:label.building']}</div>
                                <div class="description">${v.building.name}</div>
                            </div>
                        </div>
                    `: `
                        <div>
                            <i class="fa-solid fa-maximize"></i>
                            <div>
                                <div class="title">${translation.marketplace.list['featured:label.plot_area']}</div>
                                <div class="description">${v.area} ${translation.area_units[areaUnit]}</div>                                
                            </div>
                        </div>
                    `}
                `,
                `
                    
                `,
            );
        }

        $('.marketplace div[data-type="list"] .options').html(properties);
        $('.marketplace div[data-type="offer"]').hide();
        $('.marketplace, .marketplace div[data-type="list"]').fadeIn(120);
    },
    
    Close: function(data) {
        $('.marketplace div[data-type="offer"] .side-boxes>.box>.big-image').hide().empty();
        $(`.marketplace, .marketplace div[data-type="list"], .marketplace div[data-type="offer"]`).fadeOut(120)
        currentMenu = null;
    },

    ShowOffer: function(data) {
        $('.marketplace div[data-type="offer"] .side-boxes>.box>.big-image').hide().empty();
        
        let isNoRegion = data.regionData.zone != null;

        const rawImages = data.metadata?.images || {};
        const imageUrls = Object.values(rawImages);
        const imagesCount = imageUrls.length;

        let imagesElement = '';

        if (!imagesCount || imagesCount === 0) {
            imagesElement = `
                <div id="image" style="background-image: url(https://consultix.radiantthemes.com/wp-content/themes/consultix/images/no-image-found-360x250.png);"></div>
            `;
        } else if (imagesCount >= 5) {
            imagesElement = `
                <div id="image" style="background-image: url(${imageUrls[0]});"></div>
                <div class="five-images second-image">
                    <div id="image" style="background-image: url(${imageUrls[1]});"></div>
                    <div id="image" style="background-image: url(${imageUrls[2]});"></div>
                    <div id="image" style="background-image: url(${imageUrls[3]});"></div>
                    <div id="image" style="background-image: url(${imageUrls[4]});"></div>
                </div>
            `;
        } else if (imagesCount >= 4) {
            imagesElement = `
                <div id="image" style="background-image: url(${imageUrls[0]});"></div>
                <div class="four-images second-image">
                    <div id="image" style="background-image: url(${imageUrls[1]});"></div>
                    <div id="image" style="background-image: url(${imageUrls[2]});"></div>
                    <div id="image" style="background-image: url(${imageUrls[3]});"></div>
                </div>
            `;
        } else if (imagesCount >= 3) {
            imagesElement = `
                <div id="image" style="background-image: url(${imageUrls[0]});"></div>
                <div class="three-images second-image">
                    <div id="image" style="background-image: url(${imageUrls[1]});"></div>
                    <div id="image" style="background-image: url(${imageUrls[2]});"></div>
                </div>
            `;
        } else if (imagesCount >= 2) {
            imagesElement = `
                <div id="image" style="background-image: url(${imageUrls[0]});"></div>
                <div class="two-images second-image">
                    <div id="image" style="background-image: url(${imageUrls[1]});"></div>
                </div>
            `;
        } else if (imagesCount >= 1) {
            imagesElement = `
                <div id="image" style="background-image: url(${imageUrls[0]});"></div>
            `;
        }

        let propertyOffer = `
            <div id="images">${imagesElement}</div>

            <div id="main-informations">
                <div class="name">${data.name}</div>
                ${data.sale.active ? `
                    <div class="price sale-mode">
                        ${translation.currency} ${formatNumber(data.sale.price, 2, 2)}
                        ${data.metadata?.zone?.area ? `<span>${translation.currency}${formatNumber((data.sale.price / data.metadata?.zone?.area), 0, 0)}/${translation.area_units[areaUnit]}</span>` : ''}
                    </div>
                ` : ''}
                ${data.rental.active ? `
                    <div class="price rental-mode" ${data.sale.active ? 'style="display:none;"' : ''}>
                        ${translation.currency} ${formatNumber(data.rental.price, 2, 2)}
                        <span>${translation.currency}${formatNumber((data.rental.price / 30), 0, 0)}/${translation.marketplace.selected['day']}</span>
                    </div>
                ` : ''}
                <div class="offer-mode">
                    ${data.sale.active ? `<div class="market-btn active" data-type="sale">${translation.marketplace.selected['btn.for_sale']}</div>` : ''}
                    ${data.rental.active ? `<div class="market-btn ${!data.sale.active ? 'active' : ''}" data-type="rental">${translation.marketplace.selected['btn.for_rent']}</div>` : ''}
                </div>
                <div class="address"><i class="fa-solid fa-road"></i>${data.address}${isNoRegion ? `, ${data.region}` : ''} <span id="mark-on-gps" data-id="${data.id}">${translation.marketplace.selected['btn.mark_on_gps']}</span></div>
                ${allowTransactionFromMenu ? `<div class="view-contract ${data.isOwner ? 'disabled' : ''}" data-id="${data.id}">${translation.marketplace.selected['btn.sign_the_contract']}</div>` : ''}
            </div>

            <div id="property-informations">
                <div class="label">Property</div>
                <div id="table">
                    ${data.building ? `
                        <div>
                            <div>${data.building.type == "motel" ? translation.marketplace.selected['featured:motel'] : translation.marketplace.selected['featured:building']}:</div>
                            <div>${data.building.name}</div>
                        </div>
                        <hr>
                    ` : ''}

                    ${data.metadata?.contact_number ? `
                        <div>
                            <div>${translation.marketplace.selected['featured:contact_number']}:</div>
                            <div>${data.metadata?.contact_number}</div>
                        </div>
                        <hr>
                    ` : ''}

                    ${data.metadata?.zone?.area ? `
                        <div>
                            <div>${translation.marketplace.selected['featured:plot_area']}:</div>
                            <div>${data.metadata?.zone?.area} ${translation.area_units[areaUnit]}</div>
                        </div>
                        <hr>
                    ` : ''}

                    <div>
                        <div>${translation.marketplace.selected['featured:finishing_condition']}:</div>
                        <div>${data.metadata?.zone?.area ? translation.marketplace.selected['featured:finishing_condition.furnished'] : translation.marketplace.selected['featured:finishing_condition.not_furnished']}</div>
                    </div>
                    
                    <hr>

                    <div>
                        <div>${translation.marketplace.selected['featured:payments']}</div>
                        <div>
                            ${data.regionData?.electricity ? `<span>${(translation.marketplace.selected['featured:electricity']).format(translation.currency, data.regionData?.electricity.rate, data.regionData?.electricity.unit)}</span>` : ''}
                            ${data.regionData?.water ? `<span>${(translation.marketplace.selected['featured:water']).format(translation.currency, data.regionData?.water.rate, data.regionData?.water.unit)}</span>` : ''}
                            ${data.regionData?.internet ? `<span>${(translation.marketplace.selected['featured:internet']).format(translation.currency, data.regionData?.internet.flatRate)}</span>` : ''}
                        </div>
                    </div>

                    <div>
                        <div></div>
                        <div></div>
                    </div>
                </div>
            </div>

            <div id="property-description">
                <div class="label">Description</div>
                <div class="data">${data.description}</div>
            </div>
        `

        $('.marketplace div[data-type="offer"] .options').html(propertyOffer);
        $('.marketplace div[data-type="offer"]').fadeIn(120);
        $('.marketplace div[data-type="list"]').fadeOut(120);
    }
}

$(document).on('click', '.marketplace div[data-type="list"] .side-boxes>.box>.options>div', function(e) {
    const id = $(this).data('id');

    $.post(`https://${GetParentResourceName()}/marketplace:getProperty`, JSON.stringify({
        id: id
    }), function(data) {
        Marketplace.ShowOffer(data);
    });
})

$(document).on('click', '.marketplace div[data-type="offer"] .side-boxes>.box>.big-image', function(e) {
    $(this).fadeOut(120).empty();
})

$(document).on('click', '.marketplace div[data-type="offer"] #image', function(e) {
    const style = window.getComputedStyle(this);
    const backgroundImage = style.backgroundImage;
    const match = backgroundImage.match(/url\(["']?(.*?)["']?\)/);
    const url = match ? match[1] : null;

    $('.marketplace div[data-type="offer"] .side-boxes>.box>.big-image').html(`<img src="${url}">`).fadeIn(120);
});

$(document).on('click', '.marketplace div[data-type="offer"] .offer-mode div', function(e) {
    const type = $(this).data('type');
    
    $('.marketplace div[data-type="offer"] .side-boxes>.box>.options>div#main-informations>.price').hide();
    $(`.marketplace div[data-type="offer"] .side-boxes>.box>.options>div#main-informations>.price.${type}-mode`).show();

    $('.marketplace div[data-type="offer"] .offer-mode div').removeClass('active');
    $(`.marketplace div[data-type="offer"] .offer-mode div[data-type="${type}"]`).addClass('active');
});

$(document).on('click', '.marketplace div[data-type="offer"] #mark-on-gps', function(e) {
    const id = $(this).data('id');
    $.post(`https://${GetParentResourceName()}/marketplace:markOnGps`, JSON.stringify({
        id: id
    }));
});

$(document).on('click', '.marketplace div[data-type="offer"] .side-boxes>.box>.options>div#main-informations>.view-contract', function(e) {
    if ($(this).hasClass('disabled')) return;
    
    const id = $(this).data('id');
    $.post(`https://${GetParentResourceName()}/marketplace:showContract`, JSON.stringify({
        id: id
    }));
});
