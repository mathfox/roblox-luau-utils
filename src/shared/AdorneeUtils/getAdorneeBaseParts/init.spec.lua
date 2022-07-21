return function ()
   local getAdorneeBaseParts = require(script.Parent)

   it('should be a function', function()
      expect(getAdorneeBaseParts).to.be.a('function')
   end)
end