@import <AppKit/CPTableView.j>

@global CPUpArrowFunctionKey
@global CPDownArrowFunctionKey
@global CPLeftArrowFunctionKey
@global CPRightArrowFunctionKey
@global CPTabKeyCode
@global CPShiftKeyMask

var CPTableViewDelegate_tableView_shouldSelectRow_ = 1 << 9;

@implementation SpreadSheetTableView : CPTableView
{
    int _selectedColumIndex @accessors(property=selectedColumIndex);
}

- (void)_init
{
    [super _init];
    [self setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
    [self setAllowsMultipleSelection:NO];
    _selectedColumIndex = 0;

    // TODO : find a better way
    var handlekeydown=function(e){
        if (e.keyCode == 9)
            [[self window] makeFirstResponder:self];
    }

    self._DOMElement.addEventListener('keydown',handlekeydown,NO);
}

- (BOOL)performKeyEquivalent:(CPEvent)anEvent
{
    var character = [anEvent charactersIgnoringModifiers],
        modifierFlags = [anEvent modifierFlags];

    if (character === CPUpArrowFunctionKey && modifierFlags == 0 || [anEvent keyCode] == CPTabKeyCode && [anEvent modifierFlags] & CPShiftKeyMask)
    {
        if ([self selectedRow] == 0 || ![self _shouldEditTableColumn:[[self tableColumns] objectAtIndex:_selectedColumIndex] row:([self selectedRow] - 1)])
            return YES;

        [[self window] makeFirstResponder:self];
        [self _moveSelectionWithEvent:anEvent upward:YES];
        [self editColumn:_selectedColumIndex row:[self selectedRow] withEvent:anEvent select:YES];

        return YES;
    }

    if (character === CPDownArrowFunctionKey && modifierFlags == 0 || [anEvent keyCode] == CPTabKeyCode)
    {
        // Here, if you want, we can add a test and select the first cell of the next tableColumn when reaching the end of the current column

        if ([self selectedRow] == [self numberOfRows] - 1 || ![self _shouldEditTableColumn:[[self tableColumns] objectAtIndex:_selectedColumIndex] row:([self selectedRow] + 1)])
            return YES;

        [[self window] makeFirstResponder:self];
        [self _moveSelectionWithEvent:anEvent upward:NO];
        [self editColumn:_selectedColumIndex row:[self selectedRow] withEvent:anEvent select:YES];

        return YES;
    }

    if (character === CPLeftArrowFunctionKey && modifierFlags == 0)
    {
        if (_selectedColumIndex == 0 || ![self _shouldEditTableColumn:[[self tableColumns] objectAtIndex:(_selectedColumIndex - 1)] row:[self selectedRow]])
            return YES;

        [[self window] makeFirstResponder:self];
        _selectedColumIndex = MAX(0,--_selectedColumIndex);
        [self editColumn:_selectedColumIndex row:[self selectedRow] withEvent:anEvent select:YES];

        return YES;
    }

    if (character === CPRightArrowFunctionKey && modifierFlags == 0)
    {
        if (_selectedColumIndex == [self numberOfColumns] - 1 || ![self _shouldEditTableColumn:[[self tableColumns] objectAtIndex:(_selectedColumIndex + 1)] row:[self selectedRow]])
            return YES;

        [[self window] makeFirstResponder:self];
        _selectedColumIndex = MIN([self numberOfColumns] - 1, ++_selectedColumIndex);
        [self editColumn:_selectedColumIndex row:[self selectedRow] withEvent:anEvent select:YES];

        return YES;
    }

    return NO;
}

- (BOOL)startTrackingAt:(CGPoint)aPoint
{
    _selectedColumIndex = [self columnAtPoint:aPoint];

    return [super startTrackingAt:aPoint];
}

- (BOOL)_shouldEditTableColumn:(CPTableColumn)aTableColumn row:(int)rowIndex
{
    if (_implementedDelegateMethods & CPTableViewDelegate_tableView_shouldSelectRow_)
        return [_delegate tableView:self shouldEditTableColumn:aTableColumn row:rowIndex];

    return YES;
}

@end