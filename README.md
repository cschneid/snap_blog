Snap Blog
=========

I'm learning the [Snap framework][SnapFramework]. I figured the best way would be to build the
cannonical 'starter app'.

To get running yourself, you'll want to:

```bash
cabal install -f development

# Create a postgres database
createdb haskell_blog

# Update your config with postgresql connection details
vi snaplets/persist/devel.cfg

# Run the app with:
dist/build/HaskellBlog/HaskellBlog

```

[SnapFramework]: http://snapframework.com/
