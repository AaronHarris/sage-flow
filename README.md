sage-flow
=========

    rvm install 1.9.3
    rvm use 1.9.3
    rvm gemset create sage-flow
    rvm use 1.9.3@sage-flow
    git clone git@github.com:hathersagegroup/sage-flow.git
    cd sage-flow
    rvm --rvmrc --create 1.9.3@sage-flow
    gem install bundler
    bundle

Notes
=====

    Single table inheritance does not play well with class redefinition in RSpec/ActiveRecord where many tests define different classes with the same name and save them to the database
    Only an issue if using the :type column in your database
