$(document).on('click', '.property_furniture > div > .menu > #categories > #elements > div', function(e) {
    let furnitureTag = $(this).data('tag');

    if ($(this).hasClass('active')) {
        $('.property_furniture > div > .menu > #categories > #elements > div').removeClass('active');
        $('.property_furniture > div > .menu > #items > #elements > div').show();
        $('.property_furniture > div > .menu > #items > #elements > div[data-tag="theme"]').hide();
    } else {
        $('.property_furniture > div > .menu > #categories > #elements > div').removeClass('active');
        $(this).addClass('active');
        $('.property_furniture > div > .menu > #items > #elements > div').hide();
        $(`.property_furniture > div > .menu > #items > #elements > div[data-tag="${furnitureTag}"]`).show();
    }
})

$(document).on('click', '.property_furniture > div > .menu > #items > #elements > div', function(e) {
    let theme = $(this).data('theme');
    let furnitureModel = $(this).data('model');
    let furnitureId = $(this).data('id');

    if (furnitureId == 'edit') {
        $.post(`https://${GetParentResourceName()}/propertyFurniture:edit`, JSON.stringify({}));
        
    } else if (theme) {
        $.post(`https://${GetParentResourceName()}/propertyTheme:edit`, JSON.stringify({theme: theme}));

    } else {
        $.post(`https://${GetParentResourceName()}/propertyFurniture:placeNew`, JSON.stringify({
            model: furnitureModel,
            id: furnitureId,
        }));

    }
})

$('.property_furniture .menu > #items > #search > input').on('keyup', function () {
    var value = $(this).val().toLowerCase();

    $('.property_furniture>div>.menu>#categories > #elements > div').removeClass('active');
    
    $('.property_furniture .menu > #items > #elements > div').filter(function () {
        var name = $(this).find('.name').text().toLowerCase();
        $(this).toggle(name.indexOf(value) > -1);
    });
});


$(document).on('click', '.property_furniture_purchase > .purchase > .buttons > #purchase', function(e) {
    let paymentMethod = $(this).data('payment');

    $.post(`https://${GetParentResourceName()}/propertyFurniture:purchaseAccept`, JSON.stringify({
        paymentMethod: paymentMethod,
    }));
})

$(document).on('click', '.property_furniture_purchase > .purchase > .buttons > #cancel', function(e) {
    $.post(`https://${GetParentResourceName()}/propertyFurniture:purchaseCancel`, JSON.stringify({}));
})