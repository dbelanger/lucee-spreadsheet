<cfscript>	
describe( "mergeCells", function(){

	beforeEach( function(){
		var data = querySim(
			"column1,column2
			a|b
			c|d");
		workbook = s.workbookFromQuery( data, false );
	});

	it( "Retains merged cell data by default", function(){
		s.mergeCells( workbook, 1, 2, 1, 2 );
		expect( s.getCellValue( workbook, 1, 1 ) ).toBe( "a" );
		expect( s.getCellValue( workbook, 1, 2 ) ).toBe( "b" );
		expect( s.getCellValue( workbook, 2, 1 ) ).toBe( "c" );
		expect( s.getCellValue( workbook, 2, 2 ) ).toBe( "d" );
	});

	it( "Can empty all but the top-left-most cell of a merged region", function(){
		s.mergeCells( workbook, 1, 2, 1, 2, true );
		s.write( workbook, tempXlsPath, true );
		expect( s.getCellValue( workbook, 1, 1 ) ).toBe( "a" );
		expect( s.getCellValue( workbook, 1, 2 ) ).toBe( "" );
		expect( s.getCellValue( workbook, 2, 1 ) ).toBe( "" );
		expect( s.getCellValue( workbook, 2, 2 ) ).toBe( "" );
	});

	describe( "mergeCells throws an exception if", function(){

		beforeEach( function(){
			variables.workbook = s.new();
		});

		it( "startRow OR startColumn is less than 1", function(){
			expect( function(){
				s.mergeCells( workbook, 0, 0, 1, 2 );
			}).toThrow( regex="Invalid" );
			expect( function(){
				s.mergeCells( workbook, 1, 2, 0, 0 );
			}).toThrow( regex="Invalid" );
		});

		it( "endRow/endColumn is less than startRow/startColumn", function(){
			expect( function(){
				s.mergeCells( workbook, 2, 1, 1, 2 );
			}).toThrow( regex="Invalid" );
			expect( function(){
				s.mergeCells( workbook, 1, 2, 2, 1 );
			}).toThrow( regex="Invalid" );
		});

	});

	afterEach( function(){
		if( FileExists( variables.tempXlsPath ) ) FileDelete( variables.tempXlsPath );
		if( FileExists( variables.tempXlsxPath ) ) FileDelete( variables.tempXlsxPath );
	});
	
});	
</cfscript>