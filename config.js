const config = {}

config.timeZone = 'pl-PL'

config.shellsTags = {
    // Required, do not modify 'default' key value!
    'default': 'Default',
    
    // Shell state:
    'empty': 'Empty',
    'furnished': 'Furnished',

    // Creators:
    'k4mb1': 'K4MB1',
    'envi': 'ENVI',
    'dccustomz': 'DC Customz',
    'kuzquality': 'KuzQuality',
}

config.iplsTags = {
    // Required, do not modify 'default' key value!
    'default': 'Default',
    
    // Shell state:
    'furnished': 'Furnished',
    'apartment': 'Apartment',
    'office': 'Office',
}

config.furnitureTags = {
    "bed": "Beds",
    "sofa": "Sofas",
    "chair": "Chairs",
    "bathroom": "Bathroom",
    "kitchen": "Kitchen",
    "electronic": "Electronics",
    "light": "Lights",
    "plant": "Plants",
    "storage": "Storages",
    "table": "Tables",
    "decorations": "Decorations",
    "outdoor": "Outdoor",
    "recreation": "Recreation",

    "theme": "Themes",
}

config.interactableInfo = {
    wardrobe: {
        label: "Wardrobe",      // Label
        description: `
            You can dress up.
        `,
    },
    storage: {
        label: "Storage",       // Label
        description: `
            You can store your items there.
        `,
        weight: 'Max Weight',   // Metadata weight
        slots: 'Slots',         // Metadata slots
    },
    safe: {
        label: "Safe",          // Label
        description: `
            You can store your items there.
        `,
        weight: 'Max Weight',   // Metadata weight
        slots: 'Slots',         // Metadata slots
    },
    device: {
        label: "Device",        // Label
        description: `
            You can use the device to make orders from IKEA.
        `,
    },
};


config.configuratorFurnitureInteractables = [
    "wardrobe",
    "storage",
    "safe",
    "device",
]

config.configuratorFurnitureMetadata = {
    safe: [
        {key: "slots", allowedValue: "number", defaultValue: 10},
        {key: "weight", allowedValue: "number", defaultValue: 1500},
    ],
    storage: [
        {key: "slots", allowedValue: "number", defaultValue: 10},
        {key: "weight", allowedValue: "number", defaultValue: 1500},
    ],
}

config.charactersLimit = {
    name: 45,
    description: 400,
}

config.controlsList = {
    'Property:photomode_off': [
        { control: 'E',         label: 'Enter Photo Mode' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'Property:photomode_on': [
        { control: 'ENTER',     label: 'Save' },
        { control: 'E',         label: 'Exit Photo Mode' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'Property:peephole': [
        { control: 'BACKSPACE', label: 'Exit' },
    ],
    'Property:camera': [
        { control: 'ARROW LEFT', label: 'Previous' },
        { control: 'ARROW RIGHT', label: 'Next' },
        { control: 'BACKSPACE', label: 'Exit' },
    ],
    'Furniture:gizmo': [
        { control: 'ENTER',     label: 'Place' },
        { control: 'RMB',       label: 'Toggle Cursor' },
        { control: 'G',         label: 'Change Mode' },
        { control: 'X',         label: 'Translation' },
        { control: 'C',         label: 'Rotation' },
        { control: 'LEFT ALT',  label: 'Snap to Ground' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'Furniture:walkmode': [
        { control: 'ENTER',     label: 'Place' },
        { control: 'SCROLL',    label: 'Rotate' },
        { control: 'G',         label: 'Change Mode' },
        { control: 'ARROW UP',  label: '+Z Axis' },
        { control: 'ARROW DOWN',label: '-Z Axis' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'HousingCreator:polyzone': [
        { control: 'LMB',       label: 'Add Point' },
        { control: 'RMB',       label: 'Remove Previous Point' },
        { control: 'SCROLL',    label: 'Height' },
        { control: 'ENTER',     label: 'Save' },
        { control: 'BACKSPACE', label: 'Cancel' },
        { control: 'LEFT CTRL', label: 'Hold to change the lower zone' },
    ],
    'HousingCreator:doors': [
        { control: 'LMB',       label: 'Select door' },
        { control: 'ENTER',     label: 'Save' },
        { control: 'BACKSPACE', label: 'Cancel' },
        { control: 'SCROLL',    label: 'Access Distance: <span id="doors_distance_access"></span>m.' },
    ],
    'HousingCreator:garage': [
        { control: 'LMB',       label: 'Select position' },
        { control: 'SCROLL',    label: 'Rotate' },
        { control: 'LEFT CTRL', label: 'Slow down' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'HousingCreator:enter_garage': [
        { control: 'LMB',       label: 'Select position' },
        { control: 'SCROLL',    label: 'Rotate' },
        { control: 'LEFT CTRL', label: 'Slow down' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'HousingCreator:parking': [
        { control: 'LMB',       label: 'Select position' },
        { control: 'RMB',       label: 'Remove closest' },
        { control: 'SCROLL',    label: 'Rotate' },
        { control: 'LEFT CTRL', label: 'Slow down' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'HousingCreator:delivery': [
        { control: 'LMB',       label: 'Select position' },
        { control: 'SCROLL',    label: 'Rotate' },
        { control: 'LEFT CTRL', label: 'Slow down' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
    'HousingCreator:default': [
        { control: 'LMB',       label: 'Select position' },
        { control: 'BACKSPACE', label: 'Cancel' },
    ],
}