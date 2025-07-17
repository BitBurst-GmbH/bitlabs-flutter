package ai.bitlabs.bitlabs_flutter

import ai.bitlabs.sdk.data.model.bitlabs.Category
import ai.bitlabs.sdk.data.model.bitlabs.Survey

fun Survey.toMap() = mapOf(
    "category" to category.toMap(),
    "clickUrl" to clickUrl,
    "country" to country,
    "cpi" to cpi,
    "id" to id,
    "language" to language,
    "loi" to loi,
    "rating" to rating,
    "tags" to tags,
    "type" to type,
    "value" to value,
)

fun Category.toMap() = mapOf(
    "name" to name,
    "iconUrl" to iconUrl,
    "iconName" to iconName,
    "nameInternal" to nameInternal,
)