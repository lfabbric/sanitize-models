component output="false" mixin="controller,model" {

    public function init() {
        this.version = "1.3.4,1.4,1.4.1,1.4.2,1.4.3,1.4.4,1.4.5";
        return this;
    }

    function excludeFields(required array fieldlist) {
        var metadata = GetMetaData(this);
        var componentMetaData = GetComponentMetaData(metadata.name);
        lock name="componentMetaData.excludedFields" timeout="10"{
            GetComponentMetaData(metadata.name).excludedFields = fieldlist;
        }
    }

    public array function getExcludedFields() {
        var excludedFields = [];
        var metadata = GetMetaData(this);
        var componentMetaData = GetComponentMetaData(metadata.name);
        if (componentMetaData.keyExists("excludedFields")) {
            excludedFields = componentMetaData.excludedFields;
        }
        return excludedFields;
    }

    public function $objectSanitizer(required object modelObject, depth=1) {
        var excludedFields = [];
        if (depth >= 7) {
            return arguments.modelObject;
        }
        if (isObject(arguments.modelObject)) {
            excludedFields = modelObject.getExcludedFields();
        }
        if (isArray(arguments.modelObject) && arguments.modelObject.len() > 0) {
            for (var item in arguments.modelObject) {
                item = $objectSanitizer(item, depth++);
            }
        } else {
            var keyList = structKeyArray(arguments.modelObject);
            for (key in keyList) {
                if (excludedFields.findNoCase(key)) {
                    structDelete(arguments.modelObject, key);
                } else if (structKeyExists(getMetaData(arguments.modelObject[key]),'type')) {
                    arguments.modelObject[key] = $objectSanitizer(arguments.modelObject[key], depth++);
                } else if (getMetaData(arguments.modelObject[key]).name == "coldfusion.runtime.Array" && arrayLen(arguments.modelObject[key]) && getMetaData(arguments.modelObject[key][1]).keyExists('type')) {
                    for (item in arguments.modelObject[key]) {
                        item = $objectSanitizer(item, depth++);
                    }
                }
            }
        }
        return arguments.modelObject;
    }

    public function renderWith(required any data, boolean sanitize) {
        if (!isQuery(arguments.data)) {
            var isSanitizedRequired = False;
            try {
                isSanitizedRequired = get(functionName="renderWith", name="sanitize");
            } catch(any e) {}
            if ((arguments.keyExists("sanitize") && arguments.sanitize) || (!arguments.keyExists("sanitize") && isSanitizedRequired)) {
                arguments.data = $objectSanitizer(arguments.data);
            }
        }
        arguments.delete("sanitize");
        return core.renderWith(argumentCollection=arguments);
    }
}
