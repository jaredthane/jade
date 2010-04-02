
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/helper'

class ErrorDrop < Liquid::Drop
  def standard_error
    raise Liquid::StandardError, 'standard error'
  end  

  def argument_error
    raise Liquid::ArgumentError, 'argument error'
  end  
  
  def syntax_error
    raise Liquid::SyntaxError, 'syntax error'
  end  
  
end


class ErrorHandlingTest < Test::Unit::TestCase
  include Liquid
  
  def test_standard_error
    assert_nothing_raised do 
      template = Liquid::Template.parse( ' {{ errors.standard_error }} '  )
      assert_equal ' Liquid error: standard error ', template.render('errors' => ErrorDrop.new)
      
      assert_equal 1, template.errors.size
      assert_equal StandardError, template.errors.first.class
    end
  end
  
  def test_syntax    

    assert_nothing_raised do 
    
      template = Liquid::Template.parse( ' {{ errors.syntax_error }} '  )
      assert_equal ' Liquid syntax error: syntax error ', template.render('errors' => ErrorDrop.new)
      
      assert_equal 1, template.errors.size
      assert_equal SyntaxError, template.errors.first.class
      
    end
    
  end
  
  def test_argument

    assert_nothing_raised do 
    
      template = Liquid::Template.parse( ' {{ errors.argument_error }} '  )
      assert_equal ' Liquid error: argument error ', template.render('errors' => ErrorDrop.new)
      
      assert_equal 1, template.errors.size
      assert_equal ArgumentError, template.errors.first.class
      
    end
    
  end
  
  def test_unrecognized_operator
    
    assert_nothing_raised do
      
      template = Liquid::Template.parse(' {% if 1 =! 2 %}ok{% endif %} ')
      assert_equal ' Liquid error: Unknown operator =! ', template.render
      
      assert_equal 1, template.errors.size
      assert_equal Liquid::ArgumentError, template.errors.first.class
      
    end
    
  end
  
end


