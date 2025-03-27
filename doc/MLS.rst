===========
MLS Support
===========

Sierra ships with MLS support enabled out of the box. Sierra's MLS model follows the `Bell–LaPadula model <https://en.wikipedia.org/wiki/Bell%E2%80%93LaPadula_model>`_ modified to use the concept of write equality to assist with data integrity. 4 sensitivity levels are configured as follows:

- s0: unclassified
- s1: confidential
- s2: secret
- s3: topsecret

Sierra's MLS model follows a read down, write equal approach. MLS is designed to ensure data confidentiality; subjects are prevented from downgrading the classification of their data. Integrity is also protected by preventing writing up for subjects, but integrity protection is not the main goal of Sierra's MLS constraints.

Reading objects
---------------

Subjects may read objects whose security classification is at the same level or below their security clearance. Subjects may not read objects whose security classification is above their security clearance.

Writing objects
---------------
Subjects may write only to objects of the same security classification. Objects of a lower classification may not be written to in order to prevent leaking sensitive data. Objects of a higher classification may not be written to to ensure data integrity; files with a higher classification that are relied on by subjects with a higher clearance should not be modified by subjects with a lower clearance.

MLS Excemption
--------------

Subjects associated with the ``mls.exempt.typeattr`` type-attribute are exempt from all MLS constraints. The macro ``mls.exempt.type`` may be called to associate a domain with the mls excemption type-attribute.

Trusted Objects
---------------

Types associated with the ``mls.trustedobject.typeattr`` type-attribute may have subjects of all security clearances read from or write to them regardless of their security classification. The macro ``mls.trustedobject.type`` may be called to associate a type with the mls trustedobject type-attribute.

Only filesystem objects (such as files and directories) may be trustedobjects. Various objects are trustedobjects out of the box in sierra, such as ``/dev/null`` and ``/dev/zero``; use ``seinfo -xa mls.trustedobject.typeattr`` to see all trustedobjects in the current loaded policy.

Terminology
-----------
- Subject: a user or process.
- Object: a resource, typically located on the filesystem or a VFS (such as sockfs).
- Security Clearance: MLS level of a subject.
- Security Classification: MLS level of an object.
