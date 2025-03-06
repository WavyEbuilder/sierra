======
Sierra
======

Local system SELinux policy.

Building
--------

Sierra is built using the autotools build system. To build Sierra:

.. code-block:: sh

   ./autogen.sh
   ./configure
   make

Sierra has a variety of options available in the configure script to tweak the build. For more information, run `./configure --help`.

Installation
------------

Sierra has two main installation paths, modular installation and monolithic installation. The modular installation is recommended. To perform a modular installation:

.. code-block:: sh

   make modular_install

Note that the modular installation requires root privileges.

After installation, a variety of post installation steps are recommended. See the Getting Started guide for more information.

Documentation
-------------

Documentation for Sierra is provided in the form of man pages, and has a build time dependency on `scdoc <https://git.sr.ht/~sircmpwn/scdoc>`_. To build Sierra's man pages:

.. code-block:: sh

   make doc

The manual pages will then be available under `doc/`.

Licence
-------

Sierra is based off `dssp5 <https://salsa.debian.org/dgrift/dssp5>`_ which is licensed under the Unlicense. A copy of the original licence text for `dssp5 <https://salsa.debian.org/dgrift/dssp5>`_ can be found in `misc/DSSP5-LICENCE <misc/DSSP5-LICENCE>`_. All changes made on top of `dssp5 <https://salsa.debian.org/dgrift/dssp5>`_ are licensed under the GNU GPL3. A copy of the licence text for Sierra can be found in `COPYING <COPYING>`_.
