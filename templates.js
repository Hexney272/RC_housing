const CreatorShellTemplate = `

`;

const CreatorIplTemplate = `

`;

const AlertTemplate = `
    <div class="alert {0}">
        <i class="{1}"></i>
        <div class="remove"><i class="fa-solid fa-xmark"></i></div>
        <div class="data">
            <div class="label">{2}</div>
            <div class="description">{3}</div>
        </div>
    </div>
`;

const ManageElementTemplate = `
    <div>
        <div class="icon">
            <i class="{0}"></i>
        </div>
        <div class="informations">
            <div class="label">{1}</div>
            <div class="value">{2}</div>
        </div>
    </div>
`;

const ManageBillElementTemplate = `
    <div>
        <div class="icon">
            <i class="{0}"></i>
        </div>
        <div class="informations">
            <div class="label">{1}</div>
            <div class="price">{2}{3}<span>{4}</span></div>
        </div>
    </div>
`;

const ManageKeysElementTemplate = `
    <div>
        <div class="icon">
            <i class="{0}"></i>
        </div>
        <div class="informations">
            <div class="label">{1}</div>
            {2}
        </div>
    </div>
`;

const ManageFurnitureElementTemplate = `
    <div class="{0}">
        <div class="icon">
            <i class="{1}"></i>
        </div>
        <div class="informations">
            <div class="label">{2}</div>
            {3}
        </div>
    </div>
`;


const MarketplaceTemplate = `
    <div data-id="{0}">
        <div class="image" style="background-image: url({1})"></div>
        <div class="price">{2}{3}</div>
        <div class="address">{4}</div>
        <div class="info">{5}{6}{7}</div>
    </div>
`;