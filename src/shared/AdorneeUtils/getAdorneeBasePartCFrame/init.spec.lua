return function ()
   local getAdorneeBasePartCFrame = require(script.Parent)

   it('should be a function', function()
      expect(getAdorneeBasePartCFrame).to.be.a('function')
   end)
end