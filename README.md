# mongoid-undo

Super simple undo for your Mongoid app, based on both great modules
[`Mongoid::Paranoia`](http://mongoid.org/en/mongoid/docs/extras.html#paranoia) and
[`Mongoid::Versioning`](http://mongoid.org/en/mongoid/docs/extras.html#versioning).

## How does it work?

* `Mongoid::Paranoia` is used to mark documents as deleted, instead of deleting them really, otherwise restoring would be impossible ;).
* `Mongoid::Versioning` is used to keep the older versions of your document, so we can restore them.
* `Mongoid::Undo` adds an `action` field to your documents, so we can easily determine whether it was created, updated, or destroyed.

But instead of explaning all the details, you should get the idea by looking at the Usage section.

## Usage

```ruby
class Document
  include Mongoid::Document
  include Mongoid::Undo
end
```

### Creating (and undoing)

```ruby
document = Document.create
document.persisted? #=> true

document.undo
document.persisted? #=> false

document.redo # A nice alias for undo ;)
document.persisted? #=> true
```

### Updating (and undoing)

```ruby
document = Document.create(name: 'foo')

document.update_attributes(name: 'bar')
document.name #=> 'bar'

document.undo
document.name #=> 'foo'

document.redo
document.name #=> 'bar'
```

### Destroying (and undoing)

```ruby
document = Document.first

document.destroy
document.persisted? #=> false

document.undo
document.persisted? #=> true

document.redo
document.persisted? #=> false
```

## Installation

In your Gemfile:

```ruby
gem 'mongoid-undo'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

(The MIT license)

Copyright (c) 2012 Mario Uher

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
