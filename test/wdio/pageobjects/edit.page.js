'use strict';

// const Page = require( 'wdio-mediawiki/Page' );

class EditPage {
	get content() { return $( '#wpTextbox1' ); }
	get conflictingContent() { return $( '#wpTextbox2' ); }
	get displayedContent() { return $( '#mw-content-text .mw-parser-output' ); }
	get heading() { return $( '#firstHeading' ); }
	get save() { return $( '[name="wpSave"]' ); }
	get previewButton() { return $( '#wpPreview' ); }

	// openForEditing( title ) {
	// 	super.openTitle( title, { action: 'edit', vehidebetadialog: 1, hidewelcomedialog: 1 } );
	// }

	// preview( name, content ) {
	// 	this.openForEditing( name );
	// 	this.content.setValue( content );
	// 	this.previewButton.click();
	// }

	// edit( name, content ) {
	// 	this.openForEditing( name );
	// 	this.content.setValue( content );
	// 	this.save.click();
	// }

	async edit(content) {
		await this.content.setValue( content );
		await this.save.click();
	}

}

export default new EditPage();
