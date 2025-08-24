class DataPage {

    async open() {
        await $('a=Data').click();
    }
}

export default new DataPage();