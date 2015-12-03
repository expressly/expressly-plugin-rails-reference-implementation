![Expressly](https://buyexpressly.com/assets/img/expressly-logo-sm-gray.png)
# Expressly Plug-in Ruby on Rails Reference Implementation

## Overview 

This project is supplied as a reference for any developers wishing to integrate their rails e-commerce platform
with the [Expressly network](https://buyexpressly.com/).
  
The reference implementation makes use of the [Expressly Ruby SDK](https://github.com/expressly/expressly-plugin-sdk-ruby-core).

The Expressly Ruby SDK which can be installed as a gem automatically installs the expressly api controller and routes 
required for integration.


- - -

## What Am I Looking At

This project is a base rails project with an welcome/index page added to represent your shop's homepage. This is how we
created the base project:

     > rails new myshop
     > cd myshop
     > rails generate controller welcome index

After this we added 4 simple changes to get the integration working.

 1. **Added the expressly gem** - you should restrict your gem version to the same major versions as Expressly will 
 endevour to make sure there are no breaking changes within the same major version but reserve the right to modify the 
 protocol between major releases, i.e. gem 'expressly', '~> 2.0'

 1. **Implement Expressly::MerchantPluginProvider** - you will need to extend and implement all the methods belonging to 
 this class. This is the bridge between the Expressly network and your platform. The reference implementation has an 
 example in [config/application.rb](https://github.com/expressly/expressly-plugin-rails-reference-implementation/blob/master/config/application.rb).

 1. **Configure the Expressly engine** - you will need to set the default configuration by instantiating an
 [Expressly::Configuration](https://github.com/expressly/expressly-plugin-sdk-ruby-core/blob/master/lib/expressly.rb) 
 and assigning it to the default configuration on the 
 [Expressly module](https://github.com/expressly/expressly-plugin-sdk-ruby-core/blob/master/lib/expressly.rb). You can
 see an example in [config/application.rb](https://github.com/expressly/expressly-plugin-rails-reference-implementation/blob/master/config/application.rb)

 1. **Enable rendering of Expressly popup** - When an Expressly network customer selects to migrate their profile to
 your platform you will be required to display an Expressly popup to the user before they proceed. In the reference implementation
 you will notice that the MerchantPluginProvider.display_popup is implemented by add a flag to the flash and redirecting to the
 "home page". If the flag is detected on the "home page" then the HTML is fetched from Expresly server for that prospect
 and rendered directly into the footer of the page. See 
 [app/views/welcome/index.html.erb](https://github.com/expressly/expressly-plugin-rails-reference-implementation/blob/master/app/views/welcome/index.html.erb)
 
 Please note that the location and paradigms used in the reference implementation focussed on brevity and clarity to help
 the reader.

- - -

## Is That It

Pretty much. If you haven't already you'll have to register and [get your API key](https://buyexpressly.com). 
Feel free to get in touch with us if you have any questions.

- - -

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

- - -

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT).
 
 


