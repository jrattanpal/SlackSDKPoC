global class FieldData {
    global String label;
    global Object value;

    global FieldData(String label, Object value) {
        this.label = label;
        this.value = value;
    }

    global String getLabel() {
        return label;
    }

    global Object getValue() {
        return value;
    }
}