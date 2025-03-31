#Monitoring Alarm
resource "oci_monitoring_alarm" "test_alarm" {
    #Required
    compartment_id = var.compartment_id
    destinations = [oci_ons_notification_topic.test_notification_topic.id]
    display_name = var.alarm_display_name
    is_enabled = var.alarm_is_enabled
    metric_compartment_id = var.alarm_metric_compartment_id
    namespace = var.alarm_namespace
    query = var.alarm_query
    severity = var.alarm_severity

    #Optional
    alarm_summary = var.alarm_alarm_summary
    body = var.alarm_body
    defined_tags = {"Operations.CostCenter"= "42"}
    evaluation_slack_duration = var.alarm_evaluation_slack_duration
    freeform_tags = {"Department"= "Finance"}
    is_notifications_per_metric_dimension_enabled = var.alarm_is_notifications_per_metric_dimension_enabled
    message_format = var.alarm_message_format
    metric_compartment_id_in_subtree = var.alarm_metric_compartment_id_in_subtree
    notification_title = var.alarm_notification_title
    notification_version = var.alarm_notification_version
    overrides {

        #Optional
        body = var.alarm_overrides_body
        pending_duration = var.alarm_overrides_pending_duration
        query = var.alarm_overrides_query
        rule_name = oci_events_rule.test_rule.name
        severity = var.alarm_overrides_severity
    }
    pending_duration = var.alarm_pending_duration
    repeat_notification_duration = var.alarm_repeat_notification_duration
    resolution = var.alarm_resolution
    resource_group = var.alarm_resource_group
    rule_name = oci_events_rule.test_rule.name
    suppression {
        #Required
        time_suppress_from = var.alarm_suppression_time_suppress_from
        time_suppress_until = var.alarm_suppression_time_suppress_until

        #Optional
        description = var.alarm_suppression_description
    }
}