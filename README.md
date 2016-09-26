# SanitizeModels

## Purpose

Identify and exclude fields from objects and nested objects when using the renderWith feature. An example would be to exclude a hashpassword and lastipaddress when rendering JSON

## Installation

Copy zip file to your plugins folder.  It should just work.

## Basics

You can either set an overriding setting to ensure that every renderWith method is sanitized or you can specify during each use.

### config/settings.cfm
```java
<cfset set(functionName="renderWith", sanitize=true)>
```

### controllers
```java
renderWith(data=item, sanitize=true);
```

### Setup
identify fields that should be sanitized from your Model components.

```java
    component extends="Model" {

        public function init() {
            table("tableName");
            ...
            excludeFields(['hashedpassword','lastipaddress']);
            return this;
        }
        ...
}
```
