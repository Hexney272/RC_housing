Config = Config or {}

-- ▀█▀ █▀▄ ▄▀▄ █▄ █ ▄▀▀ █   ▄▀▄ ▀█▀ ██▀
--  █  █▀▄ █▀█ █ ▀█ ▄██ █▄▄ █▀█  █  █▄▄
Config.Language = 'EN' -- 'EN' / 'DE' / 'FR' / 'ES' / 'PT' / 'PL' / 'IT' / 'CZ' / 'SV'

Config.Translate = {
    ['EN'] = {
        ['control.gizmo:select'] = "Gizmo Select",
        ['control.gizmo:translation'] = "Gizmo Translation",
        ['control.gizmo:rotation'] = "Gizmo Rotation",
        
        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Apartment",
        ['blip.house_owner'] = "Owned Property",
        ['blip.house_renter'] = "Rented Property",
        ['blip.house_key_holder'] = "Owned Property",
        ['blip.house_for_sale'] = "Property For Sale",
        ['blip.marketplace'] = "Property Marketplace",
        ['blip.alarm'] = "House Alarm",

        -- Target Main:
        ['target.marketplace'] = "Marketplace",
        ['target.view_house'] = "View Offer",
        ['target.enter'] = "Enter",
        ['target.exit'] = "Exit",
        ['target.garage'] = "Garage",
        ['target.wardrobe'] = "Wardrobe",
        ['target.storage'] = "Storage",
        ['target.manage'] = "Manage",
        ['target.furniture'] = "Furniture",
        ['target.toggle_light'] = "Toggle Light",
        ['target.toggle_lock'] = "Toggle Lock",
        ['target.toggle_lock_door'] = "Toggle Lock",
        ['target.doorbell'] = "Ring the Doorbell",
        ['target.door_peephole'] = "Peephole",
        ['target.lockpick'] = "Lockpick",
        ['target.lockdown'] = "Lockdown",
        ['target.removeseal'] = "Remove Police Seal",
        ['target.raid'] = "Raid",
        ['target.complete_raid'] = "Close Doors",
        ['target.enter_underground_parking'] = "Enter parking (Floor -%s)",
        ['target.emergency_exit'] = "Emergency Exit",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Unpack shipment',
        ['target.interactable:wardrobe'] = 'Wardrobe',
        ['target.interactable:storage'] = 'Storage',
        ['target.interactable:safe'] = 'Safe',
        ['target.interactable:device'] = 'Laptop',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Wash your hands',
        ['target.interactable:sink_drink'] = 'Drink',
        ['target.interactable:shower'] = 'Take a shower',

        -- General:
        ['notify.wait'] = "Try again in a while...",
        ['notify.not_allowed'] = "You are not allowed to do that!",
        ['notify.not_enough_money'] = "You don't have enough money!",
        ['notify.reached_properties_limit'] = "You have reached properties limit!",
        
        -- Property:
        ['notify.property:purchased'] = "You've bought this property for $%s.",
        ['notify.property:rented_monthly'] = "You're now renting this property for $%s per month.",
        ['notify.property:rented_weekly'] = "You're now renting this property for $%s per week.",
        ['notify.property:already_owned'] = "You already own this property.",
        ['notify.property:marketplace_blocked_by_renter'] = "You cannot access the marketplace while this property is rented out.",
        ['notify.property:cannot_sell_with_renter'] = "You cannot sell the property while it's rented.",
        ['notify.property:sold_property'] = "You have successfully sold the property for $%s.",
        ['notify.property:purchased_theme'] = "You purchased theme %s for $%s.",
        ['notify.property:purchased_furniture'] = "You purchased furniture %s for $%s.",
        ['notify.property:ordered_furniture'] = "You have ordered furniture %s for $%s.",
        ['notify.property:reached_furniture_limit'] = "You have reached furniture limit!<br>Sell your current furniture or upgrade Furniture Limit.",
        ['notify.property:no_electricity'] = "You cannot turn on the lights - there's no electricity. Please pay your bills!",
        ['notify.property:purchased_upgrade'] = "You purchased the upgrade: %s for $%s.",
        ['notify.property:purchased_upgrade_free'] = "You received the upgrade: %s for free.",
        ['notify.property:marketplace_offer_added'] = "The property has been listed on the marketplace.",
        ['notify.property:marketplace_offer_updated'] = "The property offer has been updated.",
        ['notify.property:marketplace_offer_removed'] = "The property has been removed from the marketplace.",
        ['notify.property:marketplace_photomode_on'] = "Photo mode enabled.",
        ['notify.property:marketplace_photomode_off'] = "Photo mode disabled.",
        ['notify.property:paid_services'] = "You paid $%s for utility bills from period %s.",
        ['notify.property:paid_rent'] = "You paid $%s for the rent of period %s.",
        ['notify.property:rent_terminated_now'] = "The rental contract has been terminated immediately.",
        ['notify.property:rent_termination_scheduled'] = "The rental contract will end at the end of current month.",
        ['notify.property:rent_termination_cancelled'] = "The rental termination has been cancelled.",
        ['notify.property:wardrobe_moved'] = "You have updated the wardrobe location.",
        ['notify.property:storage_moved'] = "You have updated the storage location.",
        ['notify.property:already_have_keys'] = "This player already holds the keys to this property.",
        ['notify.property:added_keys'] = "You have passed on the key for %s.",
        ['notify.property:player_dont_have_keys'] = "This player does not hold the keys to the property.",
        ['notify.property:removed_keys'] = "You took the keys from the %s.",
        ['notify.property:reached_keys_limit'] = "You have reached keys limit!",
        ['notify.property:reached_permissions_limit'] = "You have reached players with permissions limit!",
        ['notify.property:moved_out'] = "You have successfully moved out. The rental has been terminated.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "You don't have any cameras installed.",

        -- Furniture:
        ['notify.furniture:removed'] = "Furniture #%s removed.",
        ['notify.furniture:sold'] = "Furniture #%s sold for $%s",
        ['notify.furniture:cannot_sold'] = "This furniture cannot be sold.",
        ['notify.furniture:you_are_in_furniture_mode'] = "You cannot do this because you are in furniture mode.",
        ['notify.furniture:cannot_place_inside'] = "You cannot place this furniture inside the property.",
        ['notify.furniture:inside_disabled'] = "This property does not allow furniture inside.",
        ['notify.furniture:cannot_place_outside'] = "You cannot place this furniture outside the property.",
        ['notify.furniture:outside_disabled'] = "This property does not allow outdoor furniture.",
        ['notify.furniture:no_outdoor_area'] = "This property does not have an outdoor area.",
        ['notify.furniture:outside_zone'] = "You cannot place furniture outside of the property zone.",
        ['notify.furniture:mode_cooldown'] = "You need to wait before changing mode again.",

        -- Doors:
        ['notify.doors:wait'] = "You can't open and close the door so often.",

        -- Contract:
        ['notify.contract:player_too_far'] = "The target player is too far away to sign the contract.",
        ['notify.contract:sent'] = "You have sent a property contract to %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "The other player is too far away to finalize the contract.",
        ['notify.contract:purchased_from_player'] = "You have purchased the property from %s.",
        ['notify.contract:sold_to_player'] = "You have successfully sold the property to %s.",
        ['notify.contract:rented_to_player'] = "You have successfully rented the property to %s.",
        ['notify.contract:started_rent_from_player'] = "You have rented the property from %s.",
        ['notify.contract:already_rented'] = "This property is already rented by another player.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "You have started renting the property from the marketplace.",
        ['notify.marketplace:purchased'] = "You have purchased the property from the marketplace.",
        ['notify.marketplace:rented'] = "Your property has been rented through the marketplace. It was rented by %s.",
        ['notify.marketplace:sold'] = "Your property has been sold through the marketplace. It was purchased by %s.",
        ['notify.marketplace:marked_on_gps'] = "Marked property on GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "You can't raid this property. It is protected by anti-burglary doors.",
        ['notify.raid:missing_job'] = "You don't have the required job to raid this property.",
        ['notify.raid:missing_item'] = "You are missing a required item to perform the raid.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Your attempt to break in has failed. The anti-burglary doors resisted the intrusion.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "You cannot set the same PIN as the current one.",
        ['notify.safe:wrong_old_pin_was_entered'] = "The old PIN you entered is incorrect.",
        ['notify.safe:changed_pin'] = "PIN changed from %s to %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Alarm triggered! Lockpicking attempt detected.",
        ['notify.lockpick:alarm_success'] = "Alarm triggered! The lock has been picked.",
        ['notify.lockpick:alarm_failed'] = "Alarm triggered! Lockpicking attempt failed.",
        ['notify.lockpick:missing_item'] = "You don't have a lockpick in your inventory!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "You don't have the required item in your inventory!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "You cannot remove the owner's permissions.",
        ['notify.permissions:cannot_remove_self'] = "You cannot remove your own permissions.",
        ['notify.permissions:error'] = "An error has occurred.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "You can't set it outside the yard zone!",
    },
    ['DE'] = {
        ['control.gizmo:select'] = "Gizmo Auswählen",
        ['control.gizmo:translation'] = "Gizmo Übersetzung",
        ['control.gizmo:rotation'] = "Gizmo Drehung",

        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Wohnung",
        ['blip.house_owner'] = "Eigentum",
        ['blip.house_renter'] = "Vermietetes Eigentum",
        ['blip.house_key_holder'] = "Eigentum",
        ['blip.house_for_sale'] = "Immobilie zur Verkauf",
        ['blip.marketplace'] = "Immobilienmarkt",
        ['blip.alarm'] = "Hausalarm",

        -- Target Main:
        ['target.marketplace'] = "Marktplatz",
        ['target.view_house'] = "Angebot ansehen",
        ['target.enter'] = "Eintreten",
        ['target.exit'] = "Verlassen",
        ['target.garage'] = "Garage",
        ['target.wardrobe'] = "Kleiderschrank",
        ['target.storage'] = "Lager",
        ['target.manage'] = "Verwalten",
        ['target.furniture'] = "Möbel",
        ['target.toggle_light'] = "Licht umschalten",
        ['target.toggle_lock'] = "Schloss umschalten",
        ['target.toggle_lock_door'] = "Schloss umschalten",
        ['target.doorbell'] = "Klingeln",
        ['target.door_peephole'] = "Türspion",
        ['target.lockpick'] = "Schloss knacken",
        ['target.lockdown'] = "Lockdown",
        ['target.removeseal'] = "Polizeibesiegelung entfernen",
        ['target.raid'] = "Razzia",
        ['target.complete_raid'] = "Türen schließen",
        ['target.enter_underground_parking'] = "Parken betreten (Etage -%s)",
        ['target.emergency_exit'] = "Notausgang",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Lieferung auspacken',
        ['target.interactable:wardrobe'] = 'Kleiderschrank',
        ['target.interactable:storage'] = 'Lager',
        ['target.interactable:safe'] = 'Safe',
        ['target.interactable:device'] = 'Laptop',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Hände waschen',
        ['target.interactable:sink_drink'] = 'Trinken',
        ['target.interactable:shower'] = 'Duschen',

        -- General:
        ['notify.wait'] = "Versuche es später noch einmal...",
        ['notify.not_allowed'] = "Du darfst das nicht tun!",
        ['notify.not_enough_money'] = "Du hast nicht genug Geld!",
        ['notify.reached_properties_limit'] = "Du hast das Limit für Immobilien erreicht!",

        -- Property:
        ['notify.property:purchased'] = "Du hast dieses Eigentum für $%s gekauft.",
        ['notify.property:rented_monthly'] = "Du mietest diese Immobilie jetzt für $%s pro Monat.",
        ['notify.property:rented_weekly'] = "Du mietest diese Immobilie jetzt für $%s pro Woche.",
        ['notify.property:already_owned'] = "Du besitzt dieses Eigentum bereits.",
        ['notify.property:marketplace_blocked_by_renter'] = "Du kannst nicht auf den Markt zugreifen, solange dieses Eigentum vermietet ist.",
        ['notify.property:cannot_sell_with_renter'] = "Du kannst das Eigentum nicht verkaufen, solange es vermietet ist.",
        ['notify.property:sold_property'] = "Du hast das Eigentum erfolgreich für $%s verkauft.",
        ['notify.property:purchased_theme'] = "Du hast das Theme %s für $%s gekauft.",
        ['notify.property:purchased_furniture'] = "Du hast das Möbel %s für $%s gekauft.",
        ['notify.property:ordered_furniture'] = "Du hast das Möbel %s für $%s bestellt.",
        ['notify.property:reached_furniture_limit'] = "Du hast das Möbel Limit erreicht!<br>Verkaufe deine aktuellen Möbel oder erhöhe das Möbellimit.",
        ['notify.property:no_electricity'] = "Du kannst das Licht nicht einschalten - es gibt keinen Strom. Bitte bezahle deine Rechnungen!",
        ['notify.property:purchased_upgrade'] = "Du hast das Upgrade: %s für $%s gekauft.",
        ['notify.property:purchased_upgrade_free'] = "Du hast das Upgrade: %s kostenlos erhalten.",
        ['notify.property:marketplace_offer_added'] = "Das Eigentum wurde auf dem Markt gelistet.",
        ['notify.property:marketplace_offer_updated'] = "Das Angeboteigentum wurde aktualisiert.",
        ['notify.property:marketplace_offer_removed'] = "Das Eigentum wurde vom Markt entfernt.",
        ['notify.property:marketplace_photomode_on'] = "Fotomodus aktiviert.",
        ['notify.property:marketplace_photomode_off'] = "Fotomodus deaktiviert.",
        ['notify.property:paid_services'] = "Du hast $%s für die Dienstleistungen für den Zeitraum %s bezahlt.",
        ['notify.property:paid_rent'] = "Du hast $%s für die Miete des Zeitraums %s bezahlt.",
        ['notify.property:rent_terminated_now'] = "Der Mietvertrag wurde sofort beendet.",
        ['notify.property:rent_termination_scheduled'] = "Der Mietvertrag endet am Ende des aktuellen Monats.",
        ['notify.property:rent_termination_cancelled'] = "Die Mietkündigung wurde abgebrochen.",
        ['notify.property:wardrobe_moved'] = "Du hast den Kleiderschrankstandort aktualisiert.",
        ['notify.property:storage_moved'] = "Du hast den Standort des Lagers aktualisiert.",
        ['notify.property:already_have_keys'] = "Dieser Spieler besitzt bereits die Schlüssel zu diesem Eigentum.",
        ['notify.property:added_keys'] = "Du hast den Schlüssel für %s übergeben.",
        ['notify.property:player_dont_have_keys'] = "Dieser Spieler hat nicht die Schlüssel zum Eigentum.",
        ['notify.property:removed_keys'] = "Du hast die Schlüssel vom %s genommen.",
        ['notify.property:reached_keys_limit'] = "Du hast das Schlüssellimit erreicht!",
        ['notify.property:moved_out'] = "Du bist erfolgreich ausgezogen. Die Miete wurde beendet.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "Du hast keine Kameras installiert.",

        -- Furniture:
        ['notify.furniture:removed'] = "Möbel #%s entfernt.",
        ['notify.furniture:sold'] = "Möbel #%s für $%s verkauft",
        ['notify.furniture:cannot_sold'] = "Dieses Möbel kann nicht verkauft werden.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Du kannst das nicht tun, weil du im Möbelmodus bist.",
        ['notify.furniture:cannot_place_inside'] = "Du kannst dieses Möbel nicht im Eigentum platzieren.",
        ['notify.furniture:inside_disabled'] = "Dieses Eigentum erlaubt keine Möbel im Inneren.",
        ['notify.furniture:cannot_place_outside'] = "Du kannst dieses Möbel nicht außerhalb des Eigentums platzieren.",
        ['notify.furniture:outside_disabled'] = "Dieses Eigentum erlaubt keine Gartenmöbel.",
        ['notify.furniture:no_outdoor_area'] = "Dieses Eigentum hat keine Außenbereich.",
        ['notify.furniture:outside_zone'] = "Du kannst Möbel nicht außerhalb der Eigentumszone platzieren.",
        ['notify.furniture:mode_cooldown'] = "Du musst warten, bevor du den Modus erneut ändern kannst.",

        -- Doors:
        ['notify.doors:wait'] = "Du kannst die Tür nicht so oft öffnen und schließen.",

        -- Contract:
        ['notify.contract:player_too_far'] = "Der Zielspieler ist zu weit entfernt, um den Vertrag zu unterschreiben.",
        ['notify.contract:sent'] = "Du hast einen Eigentumsvertrag an %s gesendet.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "Der andere Spieler ist zu weit entfernt, um den Vertrag abzuschließen.",
        ['notify.contract:purchased_from_player'] = "Du hast das Eigentum von %s gekauft.",
        ['notify.contract:sold_to_player'] = "Du hast das Eigentum erfolgreich an %s verkauft.",
        ['notify.contract:rented_to_player'] = "Du hast das Eigentum erfolgreich an %s vermietet.",
        ['notify.contract:started_rent_from_player'] = "Du hast das Eigentum von %s vermietet.",
        ['notify.contract:already_rented'] = "Dieses Eigentum wird bereits von einem anderen Spieler vermietet.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Du hast begonnen, das Eigentum vom Markt zu mieten.",
        ['notify.marketplace:purchased'] = "Du hast das Eigentum vom Markt gekauft.",
        ['notify.marketplace:rented'] = "Dein Eigentum wurde über den Markt vermietet. Es wurde von %s gemietet.",
        ['notify.marketplace:sold'] = "Dein Eigentum wurde über den Markt verkauft. Es wurde von %s gekauft.",
        ['notify.marketplace:marked_on_gps'] = "Eigentum auf GPS markiert.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "Du kannst dieses Eigentum nicht überfallen. Es wird durch Anti-Einbruchstüren geschützt.",
        ['notify.raid:missing_job'] = "Du hast nicht den erforderlichen Job, um dieses Eigentum zu überfallen.",
        ['notify.raid:missing_item'] = "Dir fehlt ein erforderlicher Gegenstand, um den Überfall durchzuführen.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Dein Versuch einzubrechen ist fehlgeschlagen. Die Anti-Einbruchstüren haben die Eindringung widerstanden.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "Du kannst nicht die gleiche PIN wie die aktuelle setzten.",
        ['notify.safe:wrong_old_pin_was_entered'] = "Die alte eingegebene PIN ist falsch.",
        ['notify.safe:changed_pin'] = "PIN von %s auf %s geändert.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Alarm ausgelöst! Lockpicking-Versuch erkannt.",
        ['notify.lockpick:alarm_success'] = "Alarm ausgelöst! Das Schloss wurde geknackt.",
        ['notify.lockpick:alarm_failed'] = "Alarm ausgelöst! Lockpicking-Versuch fehlgeschlagen.",
        ['notify.lockpick:missing_item'] = "Du hast kein Dietrich in deinem Inventar!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "Du hast den erforderlichen Gegenstand nicht in deinem Inventar!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "Du kannst die Berechtigungen des Eigentümers nicht entfernen.",
        ['notify.permissions:cannot_remove_self'] = "Du kannst deine eigenen Berechtigungen nicht entfernen.",
        ['notify.permissions:error'] = "Ein Fehler ist aufgetreten.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "Du kannst es nicht außerhalb der Hofzone platzieren!",
    },
    ['FR'] = {
        ['control.gizmo:select'] = "Sélection du Gizmo",
        ['control.gizmo:translation'] = "Translation du Gizmo",
        ['control.gizmo:rotation'] = "Rotation du Gizmo",
        
        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Appartement",
        ['blip.house_owner'] = "Propriété Possédée",
        ['blip.house_renter'] = "Propriété Louée",
        ['blip.house_key_holder'] = "Propriété Possédée",
        ['blip.house_for_sale'] = "Propriété À Vendre",
        ['blip.marketplace'] = "Place du Marché Immobilier",
        ['blip.alarm'] = "Alarme Maison",

        -- Target Main:
        ['target.marketplace'] = "Place du Marché",
        ['target.view_house'] = "Voir l'offre",
        ['target.enter'] = "Entrer",
        ['target.exit'] = "Sortir",
        ['target.garage'] = "Garage",
        ['target.wardrobe'] = "Garde-robe",
        ['target.storage'] = "Stockage",
        ['target.manage'] = "Gérer",
        ['target.furniture'] = "Meubles",
        ['target.toggle_light'] = "Activer/Désactiver la Lumière",
        ['target.toggle_lock'] = "Activer/Désactiver la Serrure",
        ['target.toggle_lock_door'] = "Activer/Désactiver la Serrure",
        ['target.doorbell'] = "Sonner à la Porte",
        ['target.door_peephole'] = "Œilleton",
        ['target.lockpick'] = "Crochetage",
        ['target.lockdown'] = "Confinement",
        ['target.removeseal'] = "Retirer le Sceau de Police",
        ['target.raid'] = "Raid",
        ['target.complete_raid'] = "Fermer les Portes",
        ['target.enter_underground_parking'] = "Entrer au parking (Étage -%s)",
        ['target.emergency_exit'] = "Sortie de secours",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Déballer la livraison',
        ['target.interactable:wardrobe'] = 'Garde-robe',
        ['target.interactable:storage'] = 'Stockage',
        ['target.interactable:safe'] = 'Coffre-fort',
        ['target.interactable:device'] = 'Ordinateur portable',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Lavez-vous les mains',
        ['target.interactable:sink_drink'] = 'Boire',
        ['target.interactable:shower'] = 'Prendre une douche',

        -- General:
        ['notify.wait'] = "Réessayez plus tard...",
        ['notify.not_allowed'] = "Vous n'êtes pas autorisé à faire cela!",
        ['notify.not_enough_money'] = "Vous n'avez pas assez d'argent!",
        ['notify.reached_properties_limit'] = "Vous avez atteint la limite de propriétés !",
        
        -- Property:
        ['notify.property:purchased'] = "Vous avez acheté cette propriété pour $%s.",
        ['notify.property:rented_monthly'] = "Vous louez maintenant cette propriété pour $%s par mois.",
        ['notify.property:rented_weekly'] = "Vous louez maintenant cette propriété pour $%s par semaine.",
        ['notify.property:already_owned'] = "Vous possédez déjà cette propriété.",
        ['notify.property:marketplace_blocked_by_renter'] = "Vous ne pouvez pas accéder à la place du marché tant que cette propriété est louée.",
        ['notify.property:cannot_sell_with_renter'] = "Vous ne pouvez pas vendre la propriété lorsqu'elle est louée.",
        ['notify.property:sold_property'] = "Vous avez réussi à vendre la propriété pour $%s.",
        ['notify.property:purchased_theme'] = "Vous avez acheté le thème %s pour $%s.",
        ['notify.property:purchased_furniture'] = "Vous avez acheté les meubles %s pour $%s.",
        ['notify.property:ordered_furniture'] = "Vous avez commandé les meubles %s pour $%s.",
        ['notify.property:reached_furniture_limit'] = "Vous avez atteint la limite de meubles!<br>Vendez vos meubles actuels ou améliorez la limite de meubles.",
        ['notify.property:no_electricity'] = "Vous ne pouvez pas allumer les lumières, il n'y a pas d'électricité. Veuillez payer vos factures!",
        ['notify.property:purchased_upgrade'] = "Vous avez acheté l'amélioration: %s pour $%s.",
        ['notify.property:purchased_upgrade_free'] = "Vous avez reçu l'amélioration: %s gratuitement.",
        ['notify.property:marketplace_offer_added'] = "La propriété a été listée sur la place du marché.",
        ['notify.property:marketplace_offer_updated'] = "L'offre de propriété a été mise à jour.",
        ['notify.property:marketplace_offer_removed'] = "La propriété a été retirée de la place du marché.",
        ['notify.property:marketplace_photomode_on'] = "Mode photo activé.",
        ['notify.property:marketplace_photomode_off'] = "Mode photo désactivé.",
        ['notify.property:paid_services'] = "Vous avez payé $%s pour les factures de services pour la période %s.",
        ['notify.property:paid_rent'] = "Vous avez payé $%s pour le loyer de la période %s.",
        ['notify.property:rent_terminated_now'] = "Le contrat de location a été résilié immédiatement.",
        ['notify.property:rent_termination_scheduled'] = "Le contrat de location se terminera à la fin du mois en cours.",
        ['notify.property:rent_termination_cancelled'] = "La résiliation de la location a été annulée.",
        ['notify.property:wardrobe_moved'] = "Vous avez mis à jour l'emplacement de la garde-robe.",
        ['notify.property:storage_moved'] = "Vous avez mis à jour l'emplacement du stockage.",
        ['notify.property:already_have_keys'] = "Ce joueur détient déjà les clés de cette propriété.",
        ['notify.property:added_keys'] = "Vous avez remis la clé pour %s.",
        ['notify.property:player_dont_have_keys'] = "Ce joueur ne détient pas les clés de la propriété.",
        ['notify.property:removed_keys'] = "Vous avez pris les clés du %s.",
        ['notify.property:reached_keys_limit'] = "Vous avez atteint la limite de clés!",
        ['notify.property:moved_out'] = "Vous avez déménagé avec succès. La location a été résiliée.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "Vous n'avez installé aucune caméra.",

        -- Furniture:
        ['notify.furniture:removed'] = "Meuble #%s retiré.",
        ['notify.furniture:sold'] = "Meuble #%s vendu pour $%s",
        ['notify.furniture:cannot_sold'] = "Ce meuble ne peut pas être vendu.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Vous ne pouvez pas faire cela car vous êtes en mode meubles.",
        ['notify.furniture:cannot_place_inside'] = "Vous ne pouvez pas placer ce meuble à l'intérieur de la propriété.",
        ['notify.furniture:inside_disabled'] = "Cette propriété n'autorise pas les meubles à l'intérieur.",
        ['notify.furniture:cannot_place_outside'] = "Vous ne pouvez pas placer ce meuble à l'extérieur de la propriété.",
        ['notify.furniture:outside_disabled'] = "Cette propriété n'autorise pas les meubles d'extérieur.",
        ['notify.furniture:no_outdoor_area'] = "Cette propriété n'a pas d'espace extérieur.",
        ['notify.furniture:outside_zone'] = "Vous ne pouvez pas placer de meubles en dehors de la zone de la propriété.",
        ['notify.furniture:mode_cooldown'] = "Vous devez attendre avant de changer de mode à nouveau.",

        -- Doors:
        ['notify.doors:wait'] = "Vous ne pouvez pas ouvrir et fermer la porte si souvent.",

        -- Contract:
        ['notify.contract:player_too_far'] = "Le joueur ciblé est trop loin pour signer le contrat.",
        ['notify.contract:sent'] = "Vous avez envoyé un contrat de propriété à %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "L'autre joueur est trop loin pour finaliser le contrat.",
        ['notify.contract:purchased_from_player'] = "Vous avez acheté la propriété à %s.",
        ['notify.contract:sold_to_player'] = "Vous avez vendu la propriété avec succès à %s.",
        ['notify.contract:rented_to_player'] = "Vous avez loué avec succès la propriété à %s.",
        ['notify.contract:started_rent_from_player'] = "Vous avez loué la propriété de %s.",
        ['notify.contract:already_rented'] = "Cette propriété est déjà louée par un autre joueur.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Vous avez commencé à louer la propriété depuis la place du marché.",
        ['notify.marketplace:purchased'] = "Vous avez acheté la propriété depuis la place du marché.",
        ['notify.marketplace:rented'] = "Votre propriété a été louée via la place du marché. Elle a été louée par %s.",
        ['notify.marketplace:sold'] = "Votre propriété a été vendue via la place du marché. Elle a été achetée par %s.",
        ['notify.marketplace:marked_on_gps'] = "Propriété marquée sur le GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "Vous ne pouvez pas raid cette propriété. Elle est protégée par des portes anti-effraction.",
        ['notify.raid:missing_job'] = "Vous n'avez pas le travail requis pour raid cette propriété.",
        ['notify.raid:missing_item'] = "Vous manquez d'un objet requis pour effectuer le raid.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Votre tentative d'effraction a échoué. Les portes anti-effraction ont résisté à l'intrusion.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "Vous ne pouvez pas définir le même code PIN que celui actuel.",
        ['notify.safe:wrong_old_pin_was_entered'] = "Le vieux code PIN que vous avez saisi est incorrect.",
        ['notify.safe:changed_pin'] = "Code PIN changé de %s à %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Alarme déclenchée! Tentative de crochetage détectée.",
        ['notify.lockpick:alarm_success'] = "Alarme déclenchée! La serrure a été crochetée avec succès.",
        ['notify.lockpick:alarm_failed'] = "Alarme déclenchée! La tentative de crochetage a échoué.",
        ['notify.lockpick:missing_item'] = "Vous n'avez pas de crochet de serrure dans votre inventaire!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "Vous n'avez pas l'objet requis dans votre inventaire!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "Vous ne pouvez pas supprimer les permissions du propriétaire.",
        ['notify.permissions:cannot_remove_self'] = "Vous ne pouvez pas supprimer vos propres permissions.",
        ['notify.permissions:error'] = "Une erreur s'est produite.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "Vous ne pouvez pas le placer en dehors de la zone de la cour!",
    },
    ['ES'] = {
        ['control.gizmo:select'] = "Seleccionar Gizmo",
        ['control.gizmo:translation'] = "Traducción Gizmo",
        ['control.gizmo:rotation'] = "Rotación Gizmo",
        
        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Apartamento",
        ['blip.house_owner'] = "Propiedad Propia",
        ['blip.house_renter'] = "Propiedad Alquilada",
        ['blip.house_key_holder'] = "Propiedad Propia",
        ['blip.house_for_sale'] = "Propiedad en Venta",
        ['blip.marketplace'] = "Mercado de Propiedades",
        ['blip.alarm'] = "Alarma de Casa",

        -- Target Main:
        ['target.marketplace'] = "Mercado",
        ['target.view_house'] = "Ver Oferta",
        ['target.enter'] = "Entrar",
        ['target.exit'] = "Salir",
        ['target.garage'] = "Cochera",
        ['target.wardrobe'] = "Armario",
        ['target.storage'] = "Almacén",
        ['target.manage'] = "Administrar",
        ['target.furniture'] = "Muebles",
        ['target.toggle_light'] = "Cambiar Luz",
        ['target.toggle_lock'] = "Cambiar Cerradura",
        ['target.toggle_lock_door'] = "Cambiar Cerradura",
        ['target.doorbell'] = "Timbrar",
        ['target.door_peephole'] = "Mirilla",
        ['target.lockpick'] = "Forzar Cerradura",
        ['target.lockdown'] = "Cierre",
        ['target.removeseal'] = "Remover Sello Policial",
        ['target.raid'] = "Asaltar",
        ['target.complete_raid'] = "Cerrar Puertas",
        ['target.enter_underground_parking'] = "Entrar al estacionamiento (Piso -%s)",
        ['target.emergency_exit'] = "Salida de emergencia",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Desempacar envío',
        ['target.interactable:wardrobe'] = 'Armario',
        ['target.interactable:storage'] = 'Almacén',
        ['target.interactable:safe'] = 'Caja Fuerte',
        ['target.interactable:device'] = 'Laptop',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Lavarse las manos',
        ['target.interactable:sink_drink'] = 'Beber',
        ['target.interactable:shower'] = 'Tomar una ducha',

        -- General:
        ['notify.wait'] = "Intenta de nuevo más tarde...",
        ['notify.not_allowed'] = "¡No tienes permitido hacer eso!",
        ['notify.not_enough_money'] = "¡No tienes suficiente dinero!",
        ['notify.reached_properties_limit'] = "¡Has alcanzado el límite de propiedades!",
        
        -- Property:
        ['notify.property:purchased'] = "Has comprado esta propiedad por $%s.",
        ['notify.property:rented_monthly'] = "Ahora estás alquilando esta propiedad por $%s al mes.",
        ['notify.property:rented_weekly'] = "Ahora estás alquilando esta propiedad por $%s a la semana.",
        ['notify.property:already_owned'] = "Ya posees esta propiedad.",
        ['notify.property:marketplace_blocked_by_renter'] = "No puedes acceder al mercado mientras esta propiedad esté alquilada.",
        ['notify.property:cannot_sell_with_renter'] = "No puedes vender la propiedad mientras esté alquilada.",
        ['notify.property:sold_property'] = "Has vendido la propiedad con éxito por $%s.",
        ['notify.property:purchased_theme'] = "Has comprado el tema %s por $%s.",
        ['notify.property:purchased_furniture'] = "Has comprado el mueble %s por $%s.",
        ['notify.property:ordered_furniture'] = "Has ordenado el mueble %s por $%s.",
        ['notify.property:reached_furniture_limit'] = "¡Has alcanzado el límite de muebles!<br>Vende tus muebles actuales o aumenta el Límite de Muebles.",
        ['notify.property:no_electricity'] = "No puedes encender las luces - no hay electricidad. ¡Por favor, paga tus facturas!",
        ['notify.property:purchased_upgrade'] = "Has comprado la mejora: %s por $%s.",
        ['notify.property:purchased_upgrade_free'] = "Recibiste la mejora: %s gratis.",
        ['notify.property:marketplace_offer_added'] = "La propiedad ha sido listada en el mercado.",
        ['notify.property:marketplace_offer_updated'] = "La oferta de la propiedad ha sido actualizada.",
        ['notify.property:marketplace_offer_removed'] = "La propiedad ha sido eliminada del mercado.",
        ['notify.property:marketplace_photomode_on'] = "Modo foto habilitado.",
        ['notify.property:marketplace_photomode_off'] = "Modo foto deshabilitado.",
        ['notify.property:paid_services'] = "Pagaste $%s por los recibos de servicios del período %s.",
        ['notify.property:paid_rent'] = "Pagaste $%s por el alquiler del período %s.",
        ['notify.property:rent_terminated_now'] = "El contrato de alquiler ha sido terminado inmediatamente.",
        ['notify.property:rent_termination_scheduled'] = "El contrato de alquiler terminará al final del mes actual.",
        ['notify.property:rent_termination_cancelled'] = "La terminación del contrato de alquiler ha sido cancelada.",
        ['notify.property:wardrobe_moved'] = "Has actualizado la ubicación del armario.",
        ['notify.property:storage_moved'] = "Has actualizado la ubicación del almacén.",
        ['notify.property:already_have_keys'] = "Este jugador ya tiene las llaves de esta propiedad.",
        ['notify.property:added_keys'] = "Le has dado las llaves a %s.",
        ['notify.property:player_dont_have_keys'] = "Este jugador no tiene las llaves de la propiedad.",
        ['notify.property:removed_keys'] = "Has quitado las llaves de %s.",
        ['notify.property:reached_keys_limit'] = "¡Has alcanzado el límite de llaves!",
        ['notify.property:moved_out'] = "Has salido con éxito. El alquiler ha sido terminado.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "No tienes cámaras instaladas.",

        -- Furniture:
        ['notify.furniture:removed'] = "Mueble #%s eliminado.",
        ['notify.furniture:sold'] = "Mueble #%s vendido por $%s",
        ['notify.furniture:cannot_sold'] = "Este mueble no se puede vender.",
        ['notify.furniture:you_are_in_furniture_mode'] = "No puedes hacer esto porque estás en modo de muebles.",
        ['notify.furniture:cannot_place_inside'] = "No puedes colocar este mueble dentro de la propiedad.",
        ['notify.furniture:inside_disabled'] = "Esta propiedad no permite muebles en su interior.",
        ['notify.furniture:cannot_place_outside'] = "No puedes colocar este mueble fuera de la propiedad.",
        ['notify.furniture:outside_disabled'] = "Esta propiedad no permite muebles exteriores.",
        ['notify.furniture:no_outdoor_area'] = "Esta propiedad no tiene área exterior.",
        ['notify.furniture:outside_zone'] = "No puedes colocar muebles fuera de la zona de la propiedad.",
        ['notify.furniture:mode_cooldown'] = "Debes esperar antes de cambiar de modo nuevamente.",

        -- Doors:
        ['notify.doors:wait'] = "No puedes abrir y cerrar la puerta tan seguido.",

        -- Contract:
        ['notify.contract:player_too_far'] = "El jugador objetivo está demasiado lejos para firmar el contrato.",
        ['notify.contract:sent'] = "Has enviado un contrato de propiedad a %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "El otro jugador está demasiado lejos para finalizar el contrato.",
        ['notify.contract:purchased_from_player'] = "Has comprado la propiedad de %s.",
        ['notify.contract:sold_to_player'] = "Has vendido la propiedad con éxito a %s.",
        ['notify.contract:rented_to_player'] = "Has alquilado la propiedad con éxito a %s.",
        ['notify.contract:started_rent_from_player'] = "Has alquilado la propiedad de %s.",
        ['notify.contract:already_rented'] = "Esta propiedad ya está alquilada por otro jugador.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Has comenzado a alquilar la propiedad desde el mercado.",
        ['notify.marketplace:purchased'] = "Has comprado la propiedad del mercado.",
        ['notify.marketplace:rented'] = "Tu propiedad ha sido alquilada a través del mercado. Fue alquilada por %s.",
        ['notify.marketplace:sold'] = "Tu propiedad ha sido vendida a través del mercado. Fue comprada por %s.",
        ['notify.marketplace:marked_on_gps'] = "Propiedad marcada en GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "No puedes saquear esta propiedad. Está protegida por puertas anti-robo.",
        ['notify.raid:missing_job'] = "No tienes el trabajo necesario para saquear esta propiedad.",
        ['notify.raid:missing_item'] = "Te falta un objeto requerido para realizar el asalto.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Tu intento de ingresar ha fallado. Las puertas anti-robo resistieron la intrusión.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "No puedes establecer el mismo PIN que el actual.",
        ['notify.safe:wrong_old_pin_was_entered'] = "El antiguo PIN que ingresaste es incorrecto.",
        ['notify.safe:changed_pin'] = "PIN cambiado de %s a %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "¡Alarma activada! Se detectó un intento de forzar la cerradura.",
        ['notify.lockpick:alarm_success'] = "¡Alarma activada! La cerradura ha sido forzada.",
        ['notify.lockpick:alarm_failed'] = "¡Alarma activada! El intento de forzar la cerradura falló.",
        ['notify.lockpick:missing_item'] = "¡No tienes un ganzúa en tu inventario!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "¡No tienes el objeto requerido en tu inventario!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "No puedes quitar los permisos del propietario.",
        ['notify.permissions:cannot_remove_self'] = "No puedes quitarte tus propios permisos.",
        ['notify.permissions:error'] = "Ha ocurrido un error.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "¡No puedes colocarlo fuera de la zona del patio!",
    },
    ['PT'] = {
        ['control.gizmo:select'] = "Seleção de Gizmo",
        ['control.gizmo:translation'] = "Tradução de Gizmo",
        ['control.gizmo:rotation'] = "Rotação de Gizmo",
        
        -- Blips:
        ['blip.motel'] = "Motél",
        ['blip.building'] = "Apartamento",
        ['blip.house_owner'] = "Propriedade Própria",
        ['blip.house_renter'] = "Propriedade Alugada",
        ['blip.house_key_holder'] = "Propriedade Própria",
        ['blip.house_for_sale'] = "Propriedade à Venda",
        ['blip.marketplace'] = "Mercado de Propriedades",
        ['blip.alarm'] = "Alarme de Casa",

        -- Target Main:
        ['target.marketplace'] = "Mercado",
        ['target.view_house'] = "Ver Oferta",
        ['target.enter'] = "Entrar",
        ['target.exit'] = "Sair",
        ['target.garage'] = "Garagem",
        ['target.wardrobe'] = "Guarda-roupa",
        ['target.storage'] = "Armazenamento",
        ['target.manage'] = "Gerenciar",
        ['target.furniture'] = "Móveis",
        ['target.toggle_light'] = "Alternar Luz",
        ['target.toggle_lock'] = "Alternar Trava",
        ['target.toggle_lock_door'] = "Alternar Trava",
        ['target.doorbell'] = "Tocar a Campainha",
        ['target.door_peephole'] = "Olho Mágico",
        ['target.lockpick'] = "Chave de Ganzua",
        ['target.lockdown'] = "Bloqueio",
        ['target.removeseal'] = "Remover Selo Policial",
        ['target.raid'] = "Invasão",
        ['target.complete_raid'] = "Fechar Portas",
        ['target.enter_underground_parking'] = "Entrar no estacionamento (Andar -%s)",
        ['target.emergency_exit'] = "Saída de Emergência",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Desembalar remessa',
        ['target.interactable:wardrobe'] = 'Guarda-roupa',
        ['target.interactable:storage'] = 'Armazenamento',
        ['target.interactable:safe'] = 'Cofre',
        ['target.interactable:device'] = 'Laptop',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Lavar as mãos',
        ['target.interactable:sink_drink'] = 'Beber',
        ['target.interactable:shower'] = 'Tomar um banho',

        -- General:
        ['notify.wait'] = "Tente novamente mais tarde...",
        ['notify.not_allowed'] = "Você não tem permissão para fazer isso!",
        ['notify.not_enough_money'] = "Você não tem dinheiro suficiente!",
        ['notify.reached_properties_limit'] = "Você atingiu o limite de propriedades!",

        -- Property:
        ['notify.property:purchased'] = "Você comprou esta propriedade por $%s.",
        ['notify.property:rented_monthly'] = "Agora você está alugando esta propriedade por $%s por mês.",
        ['notify.property:rented_weekly'] = "Agora você está alugando esta propriedade por $%s por semana.",
        ['notify.property:already_owned'] = "Você já é proprietário desta propriedade.",
        ['notify.property:marketplace_blocked_by_renter'] = "Você não pode acessar o mercado enquanto esta propriedade estiver alugada.",
        ['notify.property:cannot_sell_with_renter'] = "Você não pode vender a propriedade enquanto estiver alugada.",
        ['notify.property:sold_property'] = "Você vendeu com sucesso a propriedade por $%s.",
        ['notify.property:purchased_theme'] = "Você comprou o tema %s por $%s.",
        ['notify.property:purchased_furniture'] = "Você comprou o móvel %s por $%s.",
        ['notify.property:ordered_furniture'] = "Você encomendou o móvel %s por $%s.",
        ['notify.property:reached_furniture_limit'] = "Você atingiu o limite de móveis!<br>Venda seus móveis atuais ou atualize o Limite de Móveis.",
        ['notify.property:no_electricity'] = "Você não pode ligar as luzes - não há eletricidade. Por favor, pague suas contas!",
        ['notify.property:purchased_upgrade'] = "Você comprou a melhoria: %s por $%s.",
        ['notify.property:purchased_upgrade_free'] = "Você recebeu a melhoria: %s de graça.",
        ['notify.property:marketplace_offer_added'] = "A propriedade foi listada no mercado.",
        ['notify.property:marketplace_offer_updated'] = "A oferta da propriedade foi atualizada.",
        ['notify.property:marketplace_offer_removed'] = "A propriedade foi removida do mercado.",
        ['notify.property:marketplace_photomode_on'] = "Modo de foto ativado.",
        ['notify.property:marketplace_photomode_off'] = "Modo de foto desativado.",
        ['notify.property:paid_services'] = "Você pagou $%s por contas de consumo do período %s.",
        ['notify.property:paid_rent'] = "Você pagou $%s pelo aluguel do período %s.",
        ['notify.property:rent_terminated_now'] = "O contrato de aluguel foi encerrado imediatamente.",
        ['notify.property:rent_termination_scheduled'] = "O contrato de aluguel terminará no final do mês atual.",
        ['notify.property:rent_termination_cancelled'] = "O término do aluguel foi cancelado.",
        ['notify.property:wardrobe_moved'] = "Você atualizou a localização do guarda-roupa.",
        ['notify.property:storage_moved'] = "Você atualizou a localização do armazenamento.",
        ['notify.property:already_have_keys'] = "Este jogador já possui as chaves desta propriedade.",
        ['notify.property:added_keys'] = "Você passou a chave para %s.",
        ['notify.property:player_dont_have_keys'] = "Este jogador não tem as chaves da propriedade.",
        ['notify.property:removed_keys'] = "Você pegou as chaves de %s.",
        ['notify.property:reached_keys_limit'] = "Você atingiu o limite de chaves!",
        ['notify.property:moved_out'] = "Você se mudou com sucesso. O aluguel foi encerrado.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "Você não possui câmeras instaladas.",

        -- Furniture:
        ['notify.furniture:removed'] = "Móvel #%s removido.",
        ['notify.furniture:sold'] = "Móvel #%s vendido por $%s",
        ['notify.furniture:cannot_sold'] = "Este móvel não pode ser vendido.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Você não pode fazer isso porque está no modo de móveis.",
        ['notify.furniture:cannot_place_inside'] = "Você não pode colocar este móvel dentro da propriedade.",
        ['notify.furniture:inside_disabled'] = "Esta propriedade não permite móveis no interior.",
        ['notify.furniture:cannot_place_outside'] = "Você não pode colocar este móvel fora da propriedade.",
        ['notify.furniture:outside_disabled'] = "Esta propriedade não permite móveis externos.",
        ['notify.furniture:no_outdoor_area'] = "Esta propriedade não possui área externa.",
        ['notify.furniture:outside_zone'] = "Você não pode colocar móveis fora da zona da propriedade.",
        ['notify.furniture:mode_cooldown'] = "Você precisa esperar antes de mudar de modo novamente.",

        -- Doors:
        ['notify.doors:wait'] = "Você não pode abrir e fechar a porta tão rapidamente.",

        -- Contract:
        ['notify.contract:player_too_far'] = "O jogador-alvo está muito longe para assinar o contrato.",
        ['notify.contract:sent'] = "Você enviou um contrato de propriedade para %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "O outro jogador está muito longe para finalizar o contrato.",
        ['notify.contract:purchased_from_player'] = "Você comprou a propriedade de %s.",
        ['notify.contract:sold_to_player'] = "Você vendeu com sucesso a propriedade para %s.",
        ['notify.contract:rented_to_player'] = "Você alugou com sucesso a propriedade para %s.",
        ['notify.contract:started_rent_from_player'] = "Você alugou a propriedade de %s.",
        ['notify.contract:already_rented'] = "Esta propriedade já está alugada por outro jogador.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Você começou a alugar a propriedade no mercado.",
        ['notify.marketplace:purchased'] = "Você comprou a propriedade no mercado.",
        ['notify.marketplace:rented'] = "Sua propriedade foi alugada através do mercado. Foi alugada por %s.",
        ['notify.marketplace:sold'] = "Sua propriedade foi vendida através do mercado. Foi comprada por %s.",
        ['notify.marketplace:marked_on_gps'] = "Propriedade marcada no GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "Você não pode invadir esta propriedade. Ela é protegida por portas anti-intrusão.",
        ['notify.raid:missing_job'] = "Você não tem o trabalho necessário para invadir esta propriedade.",
        ['notify.raid:missing_item'] = "Você está sem um item necessário para realizar a invasão.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Sua tentativa de invasão falhou. As portas anti-intrusão resistiram à intrusão.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "Você não pode definir o mesmo PIN que o atual.",
        ['notify.safe:wrong_old_pin_was_entered'] = "O PIN antigo que você digitou está incorreto.",
        ['notify.safe:changed_pin'] = "PIN alterado de %s para %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Alarme disparado! Tentativa de lockpicking detectada.",
        ['notify.lockpick:alarm_success'] = "Alarme disparado! A fechadura foi aberta.",
        ['notify.lockpick:alarm_failed'] = "Alarme disparado! A tentativa de lockpicking falhou.",
        ['notify.lockpick:missing_item'] = "Você não tem uma chave de gancho em seu inventário!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "Você não tem o item necessário em seu inventário!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "Você não pode remover as permissões do proprietário.",
        ['notify.permissions:cannot_remove_self'] = "Você não pode remover suas próprias permissões.",
        ['notify.permissions:error'] = "Ocorreu um erro.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "Você não pode colocá-lo fora da zona do quintal!",
    },
    ['PL'] = {
        ['control.gizmo:select'] = "Wybierz Gizmo",
        ['control.gizmo:translation'] = "Przesuń Gizmo",
        ['control.gizmo:rotation'] = "Obróć Gizmo",
        
        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Apartament",
        ['blip.house_owner'] = "Własny Dom",
        ['blip.house_renter'] = "Wynajmowany Dom",
        ['blip.house_key_holder'] = "Własny Dom",
        ['blip.house_for_sale'] = "Dom Na Sprzedaż",
        ['blip.marketplace'] = "Rynek Nieruchomości",
        ['blip.alarm'] = "Alarm Domu",

        -- Target Main:
        ['target.marketplace'] = "Rynek",
        ['target.view_house'] = "Zobacz Ofertę",
        ['target.enter'] = "Wejdź",
        ['target.exit'] = "Wyjdź",
        ['target.garage'] = "Garaż",
        ['target.wardrobe'] = "Szafa",
        ['target.storage'] = "Magazyn",
        ['target.manage'] = "Zarządzaj",
        ['target.furniture'] = "Meble",
        ['target.toggle_light'] = "Światło",
        ['target.toggle_lock'] = "Zamek",
        ['target.toggle_lock_door'] = "Zamek",
        ['target.doorbell'] = "Zadzwoń do Drzwi",
        ['target.door_peephole'] = "Wizjer",
        ['target.lockpick'] = "Otwórz Zamknięte Drzwi",
        ['target.lockdown'] = "Lockdown",
        ['target.removeseal'] = "Usuń Pieczęć Policji",
        ['target.raid'] = "Napad",
        ['target.complete_raid'] = "Zamknij Drzwi",
        ['target.enter_underground_parking'] = "Wejdź do parkingu (Piętro -%s)",
        ['target.emergency_exit'] = "Wyjście awaryjne",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Rozpakuj przesyłkę',
        ['target.interactable:wardrobe'] = 'Szafa',
        ['target.interactable:storage'] = 'Magazyn',
        ['target.interactable:safe'] = 'Sejf',
        ['target.interactable:device'] = 'Laptop',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Umyj Ręce',
        ['target.interactable:sink_drink'] = 'Wypij',
        ['target.interactable:shower'] = 'Weź Prysznic',

        -- General:
        ['notify.wait'] = "Spróbuj ponownie za chwilę...",
        ['notify.not_allowed'] = "Nie masz do tego uprawnień!",
        ['notify.not_enough_money'] = "Nie masz wystarczająco pieniędzy!",
        ['notify.reached_properties_limit'] = "Osiągnąłeś limit nieruchomości!",

        -- Property:
        ['notify.property:purchased'] = "Kupiłeś tę nieruchomość za $%s.",
        ['notify.property:rented_monthly'] = "Od teraz wynajmujesz tę nieruchomość za $%s miesięcznie.",
        ['notify.property:rented_weekly'] = "Od teraz wynajmujesz tę nieruchomość za $%s tygodniowo.",
        ['notify.property:already_owned'] = "Posiadasz już tę nieruchomość.",
        ['notify.property:marketplace_blocked_by_renter'] = "Nie możesz mieć dostępu do rynku, gdy nieruchomość jest wynajęta.",
        ['notify.property:cannot_sell_with_renter'] = "Nie możesz sprzedać nieruchomości, gdy jest wynajęta.",
        ['notify.property:sold_property'] = "Pomyślnie sprzedałeś nieruchomość za $%s.",
        ['notify.property:purchased_theme'] = "Zakupiłeś motyw %s za $%s.",
        ['notify.property:purchased_furniture'] = "Zakupiłeś meble %s za $%s.",
        ['notify.property:ordered_furniture'] = "Zamówiłeś meble %s za $%s.",
        ['notify.property:reached_furniture_limit'] = "Osiągnąłeś limit mebli!<br>Sprzedaj swoje obecne meble lub zaktualizuj Limit Mebli.",
        ['notify.property:no_electricity'] = "Nie możesz włączyć świateł - nie ma prądu. Proszę opłać rachunki!",
        ['notify.property:purchased_upgrade'] = "Zakupiłeś ulepszenie: %s za $%s.",
        ['notify.property:purchased_upgrade_free'] = "Otrzymałeś ulepszenie: %s za darmo.",
        ['notify.property:marketplace_offer_added'] = "Nieruchomość została dodana do oferty na rynku.",
        ['notify.property:marketplace_offer_updated'] = "Oferta nieruchomości została zaktualizowana.",
        ['notify.property:marketplace_offer_removed'] = "Nieruchomość została usunięta z rynku.",
        ['notify.property:marketplace_photomode_on'] = "Włączony tryb zdjęć.",
        ['notify.property:marketplace_photomode_off'] = "Wyłączony tryb zdjęć.",
        ['notify.property:paid_services'] = "Zapłaciłeś $%s za rachunki za media za okres %s.",
        ['notify.property:paid_rent'] = "Zapłaciłeś $%s za wynajem za okres %s.",
        ['notify.property:rent_terminated_now'] = "Umowa wynajmu została natychmiast zakończona.",
        ['notify.property:rent_termination_scheduled'] = "Umowa wynajmu zakończy się pod koniec bieżącego miesiąca.",
        ['notify.property:rent_termination_cancelled'] = "Anulowano zakończenie wynajmu.",
        ['notify.property:wardrobe_moved'] = "Zaktualizowałeś lokalizację szafy.",
        ['notify.property:storage_moved'] = "Zaktualizowałeś lokalizację magazynu.",
        ['notify.property:already_have_keys'] = "Ten gracz już posiada klucze do tej nieruchomości.",
        ['notify.property:added_keys'] = "Przekazałeś klucz dla %s.",
        ['notify.property:player_dont_have_keys'] = "Ten gracz nie ma kluczy do nieruchomości.",
        ['notify.property:removed_keys'] = "Odebrałeś klucze od %s.",
        ['notify.property:reached_keys_limit'] = "Osiągnąłeś limit kluczy!",
        ['notify.property:moved_out'] = "Wyprowadziłeś się - wynajem został zakończony.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "Nie masz zainstalowanych żadnych kamer.",

        -- Furniture:
        ['notify.furniture:removed'] = "Usunięto mebel #%s.",
        ['notify.furniture:sold'] = "Sprzedano mebel #%s za $%s",
        ['notify.furniture:cannot_sold'] = "Tego mebla nie można sprzedać.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Nie możesz tego zrobić, ponieważ jesteś w trybie mebli.",
        ['notify.furniture:cannot_place_inside'] = "Nie możesz umieścić tego mebla wewnątrz nieruchomości.",
        ['notify.furniture:inside_disabled'] = "Ta nieruchomość nie zezwala na meble wewnątrz.",
        ['notify.furniture:cannot_place_outside'] = "Nie możesz umieścić tego mebla na zewnątrz nieruchomości.",
        ['notify.furniture:outside_disabled'] = "Ta nieruchomość nie zezwala na meble na zewnątrz.",
        ['notify.furniture:no_outdoor_area'] = "Ta nieruchomość nie ma obszaru na zewnątrz.",
        ['notify.furniture:outside_zone'] = "Nie możesz umieszczać mebli poza strefą nieruchomości.",
        ['notify.furniture:mode_cooldown'] = "Musisz poczekać przed ponownym zmienieniem trybu.",

        -- Doors:
        ['notify.doors:wait'] = "Nie możesz otwierać i zamykać drzwi tak często.",

        -- Contract:
        ['notify.contract:player_too_far'] = "Docelowy gracz jest zbyt daleko, aby podpisać kontrakt.",
        ['notify.contract:sent'] = "Wysłałeś kontrakt nieruchomości do %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "Inny gracz jest zbyt daleko, aby finalizować umowę.",
        ['notify.contract:purchased_from_player'] = "Zakupiłeś nieruchomość od %s.",
        ['notify.contract:sold_to_player'] = "Pomyślnie sprzedałeś nieruchomość do %s.",
        ['notify.contract:rented_to_player'] = "Pomyślnie wynająłeś nieruchomość do %s.",
        ['notify.contract:started_rent_from_player'] = "Wynająłeś nieruchomość od %s.",
        ['notify.contract:already_rented'] = "Ta nieruchomość jest już wynajęta przez innego gracza.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Rozpocząłeś wynajem nieruchomości z rynku.",
        ['notify.marketplace:purchased'] = "Zakupiłeś nieruchomość z rynku.",
        ['notify.marketplace:rented'] = "Twoja nieruchomość została wynajęta za pośrednictwem rynku. wynajął ją %s.",
        ['notify.marketplace:sold'] = "Twoja nieruchomość została sprzedana za pośrednictwem rynku. Zakupił ją %s.",
        ['notify.marketplace:marked_on_gps'] = "Nieruchomość zaznaczona na GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "Nie możesz napadać na tę nieruchomość. Jest chroniona przez drzwi antywłamaniowe.",
        ['notify.raid:missing_job'] = "Nie masz wymaganego stanowiska, aby zaatakować tę nieruchomość.",
        ['notify.raid:missing_item'] = "Brakuje Ci wymaganego przedmiotu do przeprowadzenia napadu.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Twoja próba włamania zakończyła się niepowodzeniem. Drzwi antywłamaniowe zapobiegły wtargnięciu.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "Nie możesz ustawić tego samego PINu co obecny.",
        ['notify.safe:wrong_old_pin_was_entered'] = "Wprowadzony stary PIN jest niepoprawny.",
        ['notify.safe:changed_pin'] = "PIN zmieniony z %s na %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Włączył się alarm! Wykryto próbę otwarcia zamka.",
        ['notify.lockpick:alarm_success'] = "Włączył się alarm! Zamek został otwarty.",
        ['notify.lockpick:alarm_failed'] = "Włączył się alarm! Próba otwarcia zamka nie powiodła się.",
        ['notify.lockpick:missing_item'] = "Nie masz wytrytu w swoim inwentarzu!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "Nie masz wymaganego przedmiotu w swoim inwentarzu!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "Nie możesz usunąć uprawnień właściciela.",
        ['notify.permissions:cannot_remove_self'] = "Nie możesz usunąć własnych uprawnień.",
        ['notify.permissions:error'] = "Wystąpił błąd.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "Nie możesz ustawić tego poza strefą ogrodu!",
    },
    ['IT'] = {
        ['control.gizmo:select'] = "Seleziona Gizmo",
        ['control.gizmo:translation'] = "Traslazione Gizmo",
        ['control.gizmo:rotation'] = "Rotazione Gizmo",
        
        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Appartamento",
        ['blip.house_owner'] = "Proprietà Posseduta",
        ['blip.house_renter'] = "Proprietà Affittata",
        ['blip.house_key_holder'] = "Proprietà Posseduta",
        ['blip.house_for_sale'] = "Proprietà in Vendita",
        ['blip.marketplace'] = "Mercato Immobiliare",
        ['blip.alarm'] = "Allarme Casa",

        -- Target Main:
        ['target.marketplace'] = "Mercato Immobiliare",
        ['target.view_house'] = "Visualizza Offerta",
        ['target.enter'] = "Entra",
        ['target.exit'] = "Esci",
        ['target.garage'] = "Garage",
        ['target.wardrobe'] = "Guardaroba",
        ['target.storage'] = "Magazzino",
        ['target.manage'] = "Gestisci",
        ['target.furniture'] = "Mobili",
        ['target.toggle_light'] = "Attiva/Disattiva Luci",
        ['target.toggle_lock'] = "Attiva/Disattiva Serratura",
        ['target.toggle_lock_door'] = "Attiva/Disattiva Serratura",
        ['target.doorbell'] = "Suona il Campanello",
        ['target.door_peephole'] = "Sbircia dal Traditore",
        ['target.lockpick'] = "Scassina Serratura",
        ['target.lockdown'] = "Lockdown",
        ['target.removeseal'] = "Rimuovi Sigillo Polizia",
        ['target.raid'] = "Raid",
        ['target.complete_raid'] = "Chiudi Porte",
        ['target.enter_underground_parking'] = "Entra nel Parcheggio (Piano -%s)",
        ['target.emergency_exit'] = "Uscita di emergenza",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Spacchetta Spedizione',
        ['target.interactable:wardrobe'] = 'Guardaroba',
        ['target.interactable:storage'] = 'Magazzino',
        ['target.interactable:safe'] = 'Cassaforte',
        ['target.interactable:device'] = 'Laptop',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Lavati le Mani',
        ['target.interactable:sink_drink'] = 'Bevi',
        ['target.interactable:shower'] = 'Fatti una Doccia',

        -- General:
        ['notify.wait'] = "Riprova tra un po'...",
        ['notify.not_allowed'] = "Non hai il permesso per fare ciò!",
        ['notify.not_enough_money'] = "Non hai abbastanza soldi!",
        ['notify.reached_properties_limit'] = "Hai raggiunto il limite delle proprietà!",

        -- Property:
        ['notify.property:purchased'] = "Hai comprato questa proprietà per $%s.",
        ['notify.property:rented_monthly'] = "Ora stai affittando questa proprietà per $%s al mese.",
        ['notify.property:rented_weekly'] = "Ora stai affittando questa proprietà per $%s a settimana.",
        ['notify.property:already_owned'] = "Possiedi già questa proprietà.",
        ['notify.property:marketplace_blocked_by_renter'] = "Non puoi accedere al mercato mentre questa proprietà è affittata.",
        ['notify.property:cannot_sell_with_renter'] = "Non puoi vendere la proprietà mentre è affittata.",
        ['notify.property:sold_property'] = "Hai venduto con successo la proprietà per $%s.",
        ['notify.property:purchased_theme'] = "Hai acquistato il tema %s per $%s.",
        ['notify.property:purchased_furniture'] = "Hai acquistato il mobile %s per $%s.",
        ['notify.property:ordered_furniture'] = "Hai ordinato il mobile %s per $%s.",
        ['notify.property:reached_furniture_limit'] = "Hai raggiunto il limite di mobili!<br>Vendi i mobili attuali o aggiorna il Limite di Mobili.",
        ['notify.property:no_electricity'] = "Non puoi accendere le luci - non c'è elettricità. Per favore paga le bollette!",
        ['notify.property:purchased_upgrade'] = "Hai acquistato l'aggiornamento: %s per $%s.",
        ['notify.property:purchased_upgrade_free'] = "Hai ricevuto l'aggiornamento: %s gratuitamente.",
        ['notify.property:marketplace_offer_added'] = "La proprietà è stata inserita nel mercato.",
        ['notify.property:marketplace_offer_updated'] = "L'offerta della proprietà è stata aggiornata.",
        ['notify.property:marketplace_offer_removed'] = "La proprietà è stata rimossa dal mercato.",
        ['notify.property:marketplace_photomode_on'] = "Modalità Foto attivata.",
        ['notify.property:marketplace_photomode_off'] = "Modalità Foto disattivata.",
        ['notify.property:paid_services'] = "Hai pagato $%s per le bollette di utilità dal periodo %s.",
        ['notify.property:paid_rent'] = "Hai pagato $%s per l'affitto del periodo %s.",
        ['notify.property:rent_terminated_now'] = "Il contratto di affitto è stato terminato immediatamente.",
        ['notify.property:rent_termination_scheduled'] = "Il contratto di affitto terminerà alla fine del mese corrente.",
        ['notify.property:rent_termination_cancelled'] = "La terminazione dell'affitto è stata annullata.",
        ['notify.property:wardrobe_moved'] = "Hai aggiornato la posizione del guardaroba.",
        ['notify.property:storage_moved'] = "Hai aggiornato la posizione del magazzino.",
        ['notify.property:already_have_keys'] = "Questo giocatore ha già le chiavi di questa proprietà.",
        ['notify.property:added_keys'] = "Hai passato la chiave a %s.",
        ['notify.property:player_dont_have_keys'] = "Questo giocatore non ha le chiavi della proprietà.",
        ['notify.property:removed_keys'] = "Hai preso le chiavi dal %s.",
        ['notify.property:reached_keys_limit'] = "Hai raggiunto il limite di chiavi!",
        ['notify.property:moved_out'] = "Hai effettuato il trasloco con successo. Il contratto di locazione è stato terminato.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "Non hai installato alcuna telecamera.",

        -- Furniture:
        ['notify.furniture:removed'] = "Mobile #%s rimosso.",
        ['notify.furniture:sold'] = "Mobile #%s venduto per $%s",
        ['notify.furniture:cannot_sold'] = "Questo mobile non può essere venduto.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Non puoi farlo perché sei in modalità arredamento.",
        ['notify.furniture:cannot_place_inside'] = "Non puoi mettere questo mobile all'interno della proprietà.",
        ['notify.furniture:inside_disabled'] = "Questa proprietà non consente mobili interni.",
        ['notify.furniture:cannot_place_outside'] = "Non puoi mettere questo mobile all'esterno della proprietà.",
        ['notify.furniture:outside_disabled'] = "Questa proprietà non consente mobili esterni.",
        ['notify.furniture:no_outdoor_area'] = "Questa proprietà non ha un'area esterna.",
        ['notify.furniture:outside_zone'] = "Non puoi mettere mobili al di fuori della zona di proprietà.",
        ['notify.furniture:mode_cooldown'] = "Devi aspettare prima di cambiare nuovamente modalità.",

        -- Doors:
        ['notify.doors:wait'] = "Non puoi aprire e chiudere la porta così spesso.",

        -- Contract:
        ['notify.contract:player_too_far'] = "Il giocatore target è troppo lontano per firmare il contratto.",
        ['notify.contract:sent'] = "Hai inviato un contratto di proprietà a %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "L'altro giocatore è troppo lontano per finalizzare il contratto.",
        ['notify.contract:purchased_from_player'] = "Hai acquistato la proprietà da %s.",
        ['notify.contract:sold_to_player'] = "Hai venduto con successo la proprietà a %s.",
        ['notify.contract:rented_to_player'] = "Hai affittato con successo la proprietà a %s.",
        ['notify.contract:started_rent_from_player'] = "Hai affittato la proprietà da %s.",
        ['notify.contract:already_rented'] = "Questa proprietà è già affittata da un altro giocatore.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Hai iniziato a affittare la proprietà dal mercato.",
        ['notify.marketplace:purchased'] = "Hai acquistato la proprietà dal mercato.",
        ['notify.marketplace:rented'] = "La tua proprietà è stata affittata attraverso il mercato. È stata affittata da %s.",
        ['notify.marketplace:sold'] = "La tua proprietà è stata venduta attraverso il mercato. È stata acquistata da %s.",
        ['notify.marketplace:marked_on_gps'] = "Proprietà contrassegnata sul GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "Non puoi fare raids su questa proprietà. È protetta da porte anti-scasso.",
        ['notify.raid:missing_job'] = "Non hai il lavoro richiesto per raidare questa proprietà.",
        ['notify.raid:missing_item'] = "Ti manca un oggetto richiesto per eseguire il raid.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Il tuo tentativo di intrusione è fallito. Le porte anti-scasso hanno resistito all'intrusione.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "Non puoi impostare lo stesso PIN di quello attuale.",
        ['notify.safe:wrong_old_pin_was_entered'] = "Il vecchio PIN che hai inserito è sbagliato.",
        ['notify.safe:changed_pin'] = "PIN cambiato da %s a %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Allarme attivato! Tentativo di scasso rilevato.",
        ['notify.lockpick:alarm_success'] = "Allarme attivato! La serratura è stata scassinata.",
        ['notify.lockpick:alarm_failed'] = "Allarme attivato! Tentativo di scasso fallito.",
        ['notify.lockpick:missing_item'] = "Non hai uno scassino nella tua inventario!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "Non hai l'oggetto richiesto nel tuo inventario!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "Non puoi rimuovere i permessi del proprietario.",
        ['notify.permissions:cannot_remove_self'] = "Non puoi rimuovere i tuoi stessi permessi.",
        ['notify.permissions:error'] = "Si è verificato un errore.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "Non puoi metterlo fuori dalla zona recintata!",
    },
    ['CZ'] = {
        ['control.gizmo:select'] = "Gizmo Vybrat",
        ['control.gizmo:translation'] = "Gizmo Překlad",
        ['control.gizmo:rotation'] = "Gizmo Rotace",

        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Apartmán",
        ['blip.house_owner'] = "Vlastněná Nemovitost",
        ['blip.house_renter'] = "Pronajatá Nemovitost",
        ['blip.house_key_holder'] = "Vlastněná Nemovitost",
        ['blip.house_for_sale'] = "Nemovitost Na Prodej",
        ['blip.marketplace'] = "Tržiště Nemovitostí",
        ['blip.alarm'] = "Poplach v Domě",

        -- Target Main:
        ['target.marketplace'] = "Tržiště",
        ['target.view_house'] = "Zobrazit Nabídku",
        ['target.enter'] = "Vstoupit",
        ['target.exit'] = "Opustit",
        ['target.garage'] = "Garáž",
        ['target.wardrobe'] = "Šatník",
        ['target.storage'] = "Skladování",
        ['target.manage'] = "Správa",
        ['target.furniture'] = "Nábytek",
        ['target.toggle_light'] = "Přepnout Světlo",
        ['target.toggle_lock'] = "Přepnout Zámek",
        ['target.toggle_lock_door'] = "Přepnout Zámek",
        ['target.doorbell'] = "Zazvonit na Zvonek",
        ['target.door_peephole'] = "Kukátko",
        ['target.lockpick'] = "Zamknout Lomítkem",
        ['target.lockdown'] = "Karanténa",
        ['target.removeseal'] = "Odstranit Policejní Pečeť",
        ['target.raid'] = "Razzia",
        ['target.complete_raid'] = "Zavřít Dveře",
        ['target.enter_underground_parking'] = "Vstoupit do parkoviště (Patro -%s)",
        ['target.emergency_exit'] = "Nouzový východ",

        -- Furniture Interactable:
        ['target.interactable:delivery'] = 'Rozbalit zásilku',
        ['target.interactable:wardrobe'] = 'Šatník',
        ['target.interactable:storage'] = 'Skladování',
        ['target.interactable:safe'] = 'Treasure',
        ['target.interactable:device'] = 'Notebook',

        -- Static Interactable:
        ['target.interactable:sink'] = 'Umyjte si ruce',
        ['target.interactable:sink_drink'] = 'Nápoj',
        ['target.interactable:shower'] = 'Vezmi si sprchu',

        -- General:
        ['notify.wait'] = "Zkuste to znovu později...",
        ['notify.not_allowed'] = "Nemáte povolení k provedení této akce!",
        ['notify.not_enough_money'] = "Nemáte dost peněz!",
        ['notify.reached_properties_limit'] = "Dosáhli jste limitu nemovitostí!",

        -- Property:
        ['notify.property:purchased'] = "Tuto nemovitost jste zakoupili za $%s.",
        ['notify.property:rented_monthly'] = "Nyní máte pronajatou tuto nemovitost za $%s měsíčně.",
        ['notify.property:rented_weekly'] = "Nyní máte pronajatou tuto nemovitost za $%s týdně.",
        ['notify.property:already_owned'] = "Tuto nemovitost již vlastníte.",
        ['notify.property:marketplace_blocked_by_renter'] = "Při pronajatém objektu nelze přistupovat na tržiště.",
        ['notify.property:cannot_sell_with_renter'] = "Nemůžete prodat nemovitost, která je pronajata.",
        ['notify.property:sold_property'] = "Nemovitost jste úspěšně prodali za $%s.",
        ['notify.property:purchased_theme'] = "Koupili jste téma %s za $%s.",
        ['notify.property:purchased_furniture'] = "Zakoupili jste nábytek %s za $%s.",
        ['notify.property:ordered_furniture'] = "Objednali jste nábytek %s za $%s.",
        ['notify.property:reached_furniture_limit'] = "Dosáhli jste limitu nábytku!<br>Prodejte svůj stávající nábytek nebo upgradeujte limit nábytku.",
        ['notify.property:no_electricity'] = "Nemůžete zapnout světla - není el. energie. Prosím, zaplaťte účty!",
        ['notify.property:purchased_upgrade'] = "Zakoupili jste upgrade: %s za $%s.",
        ['notify.property:purchased_upgrade_free'] = "Obdrželi jste upgrade: %s zdarma.",
        ['notify.property:marketplace_offer_added'] = "Nemovitost byla umístěna na tržiště.",
        ['notify.property:marketplace_offer_updated'] = "Nabídka na nemovitost byla aktualizována.",
        ['notify.property:marketplace_offer_removed'] = "Nemovitost byla odstraněna z tržiště.",
        ['notify.property:marketplace_photomode_on'] = "Foto režim aktivován.",
        ['notify.property:marketplace_photomode_off'] = "Foto režim deaktivován.",
        ['notify.property:paid_services'] = "Zaplatili jste $%s za platby za služby za časové období %s.",
        ['notify.property:paid_rent'] = "Zaplatili jste $%s za nájem za období %s.",
        ['notify.property:rent_terminated_now'] = "Nájemní smlouva byla okamžitě ukončena.",
        ['notify.property:rent_termination_scheduled'] = "Nájemní smlouva skončí ke konci současného měsíce.",
        ['notify.property:rent_termination_cancelled'] = "Zrušení nájemní smlouvy bylo zrušeno.",
        ['notify.property:wardrobe_moved'] = "Aktualizovali jste polohu šatníku.",
        ['notify.property:storage_moved'] = "Aktualizovali jste polohu skladování.",
        ['notify.property:already_have_keys'] = "Tento hráč již vlastní klíče k této nemovitosti.",
        ['notify.property:added_keys'] = "Předali jste klíč pro %s.",
        ['notify.property:player_dont_have_keys'] = "Tento hráč nemá klíče k objektu.",
        ['notify.property:removed_keys'] = "Vzali jste klíče od %s.",
        ['notify.property:reached_keys_limit'] = "Dosáhli jste limitu klíčů!",
        ['notify.property:moved_out'] = "Úspěšně jste se vystěhovali. Pronájem byl ukončen.",

        -- Cameras:
        ['notify.cameras:no_cameras_installed'] = "Nemáte nainstalovány žádné kamery.",

        -- Furniture:
        ['notify.furniture:removed'] = "Nábytek #%s odstraněn.",
        ['notify.furniture:sold'] = "Nábytek #%s prodáno za $%s",
        ['notify.furniture:cannot_sold'] = "Tento nábytek nelze prodat.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Tohle nemůžete udělat, protože jste v režimu nábytku.",
        ['notify.furniture:cannot_place_inside'] = "Tento nábytek nelze umístit dovnitř nemovitosti.",
        ['notify.furniture:inside_disabled'] = "Tato nemovitost nepovoluje nábytek uvnitř.",
        ['notify.furniture:cannot_place_outside'] = "Tento nábytek nelze umístit ven z nemovitosti.",
        ['notify.furniture:outside_disabled'] = "Tato nemovitost neumožňuje venkovní nábytek.",
        ['notify.furniture:no_outdoor_area'] = "Tato nemovitost nemá venkovní prostor.",
        ['notify.furniture:outside_zone'] = "Nemůžete umístit nábytek mimo zónu nemovitosti.",
        ['notify.furniture:mode_cooldown'] = "Musíte počkat před dalším změnou režimu.",

        -- Doors:
        ['notify.doors:wait'] = "Nemůžete tak často otevírat a zavírat dveře.",

        -- Contract:
        ['notify.contract:player_too_far'] = "Cílový hráč je příliš daleko na podepsání smlouvy.",
        ['notify.contract:sent'] = "Odeslali jste smlouvu o nemovitosti %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "Druhý hráč je příliš daleko na dokončení smlouvy.",
        ['notify.contract:purchased_from_player'] = "Úspěšně jste koupili nemovitost od %s.",
        ['notify.contract:sold_to_player'] = "Úspěšně jste prodali nemovitost hráči %s.",
        ['notify.contract:rented_to_player'] = "Úspěšně jste pronajali nemovitost hráči %s.",
        ['notify.contract:started_rent_from_player'] = "Pronajali jste nemovitost od hráče %s.",
        ['notify.contract:already_rented'] = "Tato nemovitost je již pronajata jiným hráčem.",

        -- Marketplace:
        ['notify.marketplace:started_rent'] = "Začali jste pronajímat nemovitost z tržiště.",
        ['notify.marketplace:purchased'] = "Zakoupili jste nemovitost z tržiště.",
        ['notify.marketplace:rented'] = "Vaše nemovitost byla pronajata prostřednictvím tržiště. Pronajal ji %s.",
        ['notify.marketplace:sold'] = "Vaše nemovitost byla prodána prostřednictvím tržiště. Zakoupil ji %s.",
        ['notify.marketplace:marked_on_gps'] = "Označená nemovitost na GPS.",

        -- Raid:
        ['notify.raid:anti_burglary_doors'] = "Nemůžete provést razzii na tuto nemovitost. Je chráněna proti vniknutí proti loupežné dveře.",
        ['notify.raid:missing_job'] = "Nemáte potřebné zaměstnání k provedení razzie na tuto nemovitost.",
        ['notify.raid:missing_item'] = "Chybí vám potřebný předmět k provedení razzie.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Vaše pokus o vniknutí selhal. Protizlodějské dveře odolaly invazi.",

        -- Safe:
        ['notify.safe:cannot_set_same_pin'] = "Nemůžete nastavit stejný PIN jako aktuální.",
        ['notify.safe:wrong_old_pin_was_entered'] = "Zadali jste nesprávný starý PIN.",
        ['notify.safe:changed_pin'] = "PIN změněn z %s na %s.",

        -- Lockpick:
        ['notify.lockpick:alarm_start'] = "Poplach spuštěn! Detekován pokus o vloupání.",
        ['notify.lockpick:alarm_success'] = "Poplach spuštěn! Zámek byl otevřen lomítkem.",
        ['notify.lockpick:alarm_failed'] = "Poplach spuštěn! Pokus o lámání zámku selhal.",
        ['notify.lockpick:missing_item'] = "Nemáte lomítko ve svém inventáři!",

        -- Lockdown:
        ['notify.lockdown:missing_item'] = "Nemáte požadovaný předmět ve svém inventáři!",

        -- Permissions:
        ['notify.permissions:cannot_remove_owner'] = "Nemůžete odebrat oprávnění vlastníka.",
        ['notify.permissions:cannot_remove_self'] = "Nemůžete odebrat vlastní oprávnění.",
        ['notify.permissions:error'] = "Došlo k chybě.",

        -- Creator:
        ['notify.creator:out_of_zone'] = "Nemůžete nastavit to mimo zónu zahrady!",
    },
    ['SV'] = {
        ['control.gizmo:select'] = "Gizmo Välj",
        ['control.gizmo:translation'] = "Gizmo Översättning",
        ['control.gizmo:rotation'] = "Gizmo Rotation",

        -- Blips:
        ['blip.motel'] = "Motel",
        ['blip.building'] = "Lägenhet",
        ['blip.house_owner'] = "Ägd Egendom",
        ['blip.house_renter'] = "Hyrd Egendom",
        ['blip.house_key_holder'] = "Ägd Egendom",
        ['blip.house_for_sale'] = "Fastighet Till Salu",
        ['blip.marketplace'] = "Fastighetsmarknaden",
        ['blip.alarm'] = "Hus Larm",

        -- Target Main:
        ['target.marketplace'] = "Marknadsplats",
        ['target.view_house'] = "Visa Erbjudande",
        ['target.enter'] = "Gå in",
        ['target.exit'] = "Gå ut",
        ['target.garage'] = "Garage",
        ['target.wardrobe'] = "Garderob",
        ['target.storage'] = "Förvaring",
        ['target.manage'] = "Hantera",
        ['target.furniture'] = "Möbler",
        ['target.toggle_light'] = "Växla Ljus",
        ['target.toggle_lock'] = "Växla Lås",
        ['target.toggle_lock_door'] = "Växla Lås",
        ['target.doorbell'] = "Ring på Dörrklockan",
        ['target.door_peephole'] = "Dörrkikare",
        ['target.lockpick'] = "Låsknackning",
        ['target.lockdown'] = "Låsning",
        ['target.removeseal'] = "Ta bort Polissegel",
        ['target.raid'] = "Räd",
        ['target.complete_raid'] = "Stäng Dörrar",
        ['target.enter_underground_parking'] = "Gå in i parkering (Våning -%s)",
        ['target.emergency_exit'] = "Nödutgång",

        -- Möbler Interagerbar:
        ['target.interactable:delivery'] = 'Packa upp leveransen',
        ['target.interactable:wardrobe'] = 'Garderob',
        ['target.interactable:storage'] = 'Förvaring',
        ['target.interactable:safe'] = 'Kassaskåp',
        ['target.interactable:device'] = 'Laptop',

        -- Statisk Interagerbar:
        ['target.interactable:sink'] = 'Tvätta händerna',
        ['target.interactable:sink_drink'] = 'Drick',
        ['target.interactable:shower'] = 'Ta en dusch',

        -- Allmänt:
        ['notify.wait'] = "Försök igen om en stund...",
        ['notify.not_allowed'] = "Du har inte tillstånd att göra det!",
        ['notify.not_enough_money'] = "Du har inte tillräckligt med pengar!",
        ['notify.reached_properties_limit'] = "Du har nått fastighetsgränsen!",

        -- Egendom:
        ['notify.property:purchased'] = "Du har köpt denna egendom för $%s.",
        ['notify.property:rented_monthly'] = "Du hyr nu denna egenskap för $%s per månad.",
        ['notify.property:rented_weekly'] = "Du hyr nu denna egenskap för $%s per vecka.",
        ['notify.property:already_owned'] = "Du äger redan denna egendom.",
        ['notify.property:marketplace_blocked_by_renter'] = "Du kan inte komma åt marknadsplatsen medan denna egendom är uthyrd.",
        ['notify.property:cannot_sell_with_renter'] = "Du kan inte sälja egendomen medan den är uthyrd.",
        ['notify.property:sold_property'] = "Du har framgångsrikt sålt egendomen för $%s.",
        ['notify.property:purchased_theme'] = "Du köpte temat %s för $%s.",
        ['notify.property:purchased_furniture'] = "Du köpte möblerna %s för $%s.",
        ['notify.property:ordered_furniture'] = "Du har beställt möbler %s för $%s.",
        ['notify.property:reached_furniture_limit'] = "Du har nått möbelbegränsningen!<br>Sälj dina nuvarande möbler eller uppgradera Möbelbegränsningen.",
        ['notify.property:no_electricity'] = "Du kan inte sätta på ljuset - det finns ingen elektricitet. Vänligen betala dina räkningar!",
        ['notify.property:purchased_upgrade'] = "Du köpte uppgraderingen: %s för $%s.",
        ['notify.property:purchased_upgrade_free'] = "Du fick uppgraderingen: %s gratis.",
        ['notify.property:marketplace_offer_added'] = "Egendomen har lagts upp på marknadsplatsen.",
        ['notify.property:marketplace_offer_updated'] = "Egendomsbudet har uppdaterats.",
        ['notify.property:marketplace_offer_removed'] = "Egendomen har tagits bort från marknadsplatsen.",
        ['notify.property:marketplace_photomode_on'] = "Fotoläge aktiverat.",
        ['notify.property:marketplace_photomode_off'] = "Fotoläge inaktiverat.",
        ['notify.property:paid_services'] = "Du betalade $%s för hushållsräkning för perioden %s.",
        ['notify.property:paid_rent'] = "Du betalade $%s för hyran för perioden %s.",
        ['notify.property:rent_terminated_now'] = "Hyresavtalet har avslutats omedelbart.",
        ['notify.property:rent_termination_scheduled'] = "Hyresavtalet kommer att upphöra vid slutet av nuvarande månad.",
        ['notify.property:rent_termination_cancelled'] = "Uppsägningen av hyresavtalet har avbrutits.",
        ['notify.property:wardrobe_moved'] = "Du har uppdaterat garderobsplatsen.",
        ['notify.property:storage_moved'] = "Du har uppdaterat förvaringsplatsen.",
        ['notify.property:already_have_keys'] = "Denna spelare har redan nycklarna till denna egendom.",
        ['notify.property:added_keys'] = "Du har lämnat över nyckeln för %s.",
        ['notify.property:player_dont_have_keys'] = "Denna spelare har inte nycklarna till egendomen.",
        ['notify.property:removed_keys'] = "Du tog nycklarna från %s.",
        ['notify.property:reached_keys_limit'] = "Du har nått nyckelgränsen!",
        ['notify.property:moved_out'] = "Du har flyttat ut framgångsrikt. Uthyrningen har avslutats.",

        -- Kameror:
        ['notify.cameras:no_cameras_installed'] = "Du har inga kameror installerade.",

        -- Möbler:
        ['notify.furniture:removed'] = "Möbel #%s borttagen.",
        ['notify.furniture:sold'] = "Möbel #%s såld för $%s",
        ['notify.furniture:cannot_sold'] = "Denna möbel kan inte säljas.",
        ['notify.furniture:you_are_in_furniture_mode'] = "Du kan inte göra detta eftersom du är i möbel-läge.",
        ['notify.furniture:cannot_place_inside'] = "Du kan inte placera denna möbel inuti egendomen.",
        ['notify.furniture:inside_disabled'] = "Denna egendom tillåter inte möbler inuti.",
        ['notify.furniture:cannot_place_outside'] = "Du kan inte placera denna möbel utanför egendomen.",
        ['notify.furniture:outside_disabled'] = "Denna egendom tillåter inte utomhusmöbler.",
        ['notify.furniture:no_outdoor_area'] = "Denna egendom har ingen utomhusyta.",
        ['notify.furniture:outside_zone'] = "Du kan inte placera möbler utanför egendomens zon.",
        ['notify.furniture:mode_cooldown'] = "Du måste vänta innan du ändrar läge igen.",

        -- Dörrar:
        ['notify.doors:wait'] = "Du kan inte öppna och stänga dörren så ofta.",

        -- Kontrakt:
        ['notify.contract:player_too_far'] = "Målet spelare är för långt borta för att skriva under kontraktet.",
        ['notify.contract:sent'] = "Du har skickat ett egendomskontrakt till %s.",
        ['notify.contract:canceled'] = "The player has not signed a contract.",
        ['notify.contract:seller_too_far'] = "Den andra spelaren är för långt borta för att slutföra kontraktet.",
        ['notify.contract:purchased_from_player'] = "Du har köpt egendomen från %s.",
        ['notify.contract:sold_to_player'] = "Du har framgångsrikt sålt egendomen till %s.",
        ['notify.contract:rented_to_player'] = "Du har framgångsrikt hyrt ut egendomen till %s.",
        ['notify.contract:started_rent_from_player'] = "Du har hyrt egendomen från %s.",
        ['notify.contract:already_rented'] = "Denna egendom är redan uthyrd av en annan spelare.",

        -- Marknadsplats:
        ['notify.marketplace:started_rent'] = "Du har börjat hyra egendomen från marknadsplatsen.",
        ['notify.marketplace:purchased'] = "Du har köpt egendomen från marknadsplatsen.",
        ['notify.marketplace:rented'] = "Din egendom har hyrts ut via marknadsplatsen. Den hyrdes av %s.",
        ['notify.marketplace:sold'] = "Din egendom har sålts via marknadsplatsen. Den köptes av %s.",
        ['notify.marketplace:marked_on_gps'] = "Markerad egendom på GPS.",

        -- Räd:
        ['notify.raid:anti_burglary_doors'] = "Du kan inte råna denna egendom. Den skyddas av anti-inbrottsdörrar.",
        ['notify.raid:missing_job'] = "Du har inte det nödvändiga jobbet för att råna denna egendom.",
        ['notify.raid:missing_item'] = "Du saknar en nödvändig artikel för att utföra rånet.",
        ['notify.raid:failed_due_to_anti_burglary'] = "Ditt försök att bryta dig in har misslyckats. Anti-inbrottsdörrarna motstod intrånget.",

        -- Kassaskåp:
        ['notify.safe:cannot_set_same_pin'] = "Du kan inte ställa in samma PIN som den nuvarande.",
        ['notify.safe:wrong_old_pin_was_entered'] = "Den gamla PIN-koden du angav är felaktig.",
        ['notify.safe:changed_pin'] = "PIN-koden ändrades från %s till %s.",

        -- Låsknackning:
        ['notify.lockpick:alarm_start'] = "Larm utlöst! Låsknackeriförsök upptäckt.",
        ['notify.lockpick:alarm_success'] = "Larm utlöst! Låset har knäckts.",
        ['notify.lockpick:alarm_failed'] = "Larm utlöst! Låsknackeriförsöket misslyckades.",
        ['notify.lockpick:missing_item'] = "Du har inte en låsknack i din inventory!",

        -- Låsning:
        ['notify.lockdown:missing_item'] = "Du har inte den nödvändiga artikeln i din inventory!",

        -- Behörigheter:
        ['notify.permissions:cannot_remove_owner'] = "Du kan inte ta bort ägarens behörigheter.",
        ['notify.permissions:cannot_remove_self'] = "Du kan inte ta bort dina egna behörigheter.",
        ['notify.permissions:error'] = "Ett fel har inträffat.",

        -- Skapare:
        ['notify.creator:out_of_zone'] = "Du kan inte ställa det utanför gårdszonen!",
    },
}

TRANSLATE = function(name, ...)
    if Config.Translate[Config.Language] then
        if ... then
            return Config.Translate[Config.Language][name]:format(...)
        else
            return Config.Translate[Config.Language][name]
        end
    else
        if ... then
            return Config.Translate['EN'][name]:format(...)
        else
            return Config.Translate['EN'][name]
        end
    end
end
