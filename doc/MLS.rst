===========
MLS Support
===========

Sierra ships with MLS support enabled out of the box. Sierra's MLS model follows the `Bell–LaPadula model <https://en.wikipedia.org/wiki/Bell%E2%80%93LaPadula_model>`_. 4 sensitivity levels are configured as follows:

- s0: unclassified
- s1: confidential
- s2: secret
- s3: topsecret

The MLS model follows a read down, write up approach. MLS is designed to ensure data confidentiality; subjects are prevented from downgrading the classification of their data.

Reading objects
---------------

Subjects may read objects whose security classification is at the same level or below their security clearance. Subjects may not read objects whose security classification is above their security clearance.

Writing objects
---------------
Subjects may write to objects of the same or higher security classification. Objects of a lower classification may not be written to in order to prevent leaking sensitive data.

MLS Excemption
--------------

Subjects associated with the :mls.exempt.typeattr: type-attribute are exempt from all MLS constraints. The macro :mls.exempt.type: may be called to associate a domain with the mls excemption type-attribute.

Terminology
-----------
- Subject: a user or process.
- Object: a resource, typically located on the filesystem or a VFS (such as sockfs).
- Security Clearance: MLS level of a subject.
- Security Classification: MLS level of an object.
