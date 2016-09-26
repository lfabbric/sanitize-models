component output="false" mixin="controller,model" {

    public function init() {
        this.version = "1.3.3,1.3.4";
        return this;
	}

    function excludeFields(required array fieldlist) {
        var metadata = GetMetaData(this);
        lock name="metadata.excludeFields" timeout="10"{
            metadata.excludeFields = fieldlist;
        }
    }

    function getExcludedFields() {
        return GetMetaData(this)["EXCLUDEFIELDS"];
    }


    public function $preJSONSerialize(object, depth=1) {
        if (depth >= 7) {
            return arguments.object;
        }
        var excludeFields = [];
        if (structKeyExists(getMetaData(arguments.object), "excludefields")) {
            excludeFields = getMetaData(arguments.object).excludefields;
        }

        if (isArray(arguments.object) && arrayLen(arguments.object)) {
            depth++;
            for (var i=1; i<=arrayLen(arguments.object);i++) {
                arguments.object[i] = this.$preJSONSerialize(arguments.object[i], depth);
            }
        } else {
            var keyList = structKeyArray(arguments.object);
            for (var j=1; j<=arrayLen(keyList); j++) {
                var element = keyList[j];
                if (arrayFindNoCase(excludeFields, element)) {
                    structDelete(arguments.object, element);
                } else if (structKeyExists(getMetaData(arguments.object[element]),'type')) {
                    arguments.object[element] = this.$preJSONSerialize(arguments.object[element], depth++);
                } else if (getMetaData(arguments.object[element]).name == "coldfusion.runtime.Array" && arrayLen(arguments.object[element]) && structKeyExists(getMetaData(arguments.object[element][1]),'type')) {
                    for (var k=1; k<=arrayLen(arguments.object[element]);k++) {
                        arguments.object[element][k] = this.$preJSONSerialize(arguments.object[element][k], depth);
                    }
                }
            }
        }
        return arguments.object;
    }

    public function renderWith(required any data, string controller, string action, string template, any layout, any cache, string returnAs, boolean hideDebugInformation, boolean sanitize) {
        isSanitizedRequired = True;
        try {
            isSanitizedRequired = get(functionName="renderWith", name="sanitize");
        } catch(any e) {}

        if (structKeyExists(arguments, "sanitize") && arguments.sanitize || !structKeyExists(arguments, "sanitize") && isSanitizedRequired) {
            arguments.data = this.$preJSONSerialize(arguments.data);
        }
        return core.renderWith(argumentCollection=arguments);
    }

}
