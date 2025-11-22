class ProductsModel {
    ProductsModel({
        required this.code,
        required this.product,
        required this.status,
        required this.statusVerbose,
    });

    final String code;
    final Product? product;
    final num status;
    final String statusVerbose;

    factory ProductsModel.fromJson(Map<String, dynamic> json){ 
        return ProductsModel(
            code: json["code"] ?? "",
            product: json["product"] == null ? null : Product.fromJson(json["product"]),
            status: json["status"] ?? 0,
            statusVerbose: json["status_verbose"] ?? "",
        );
    }

}

class Product {
    Product({
        required this.allergensTags,
        required this.brands,
        required this.categoriesTags,
        required this.ecoscoreGrade,
        required this.imageUrl,
        required this.ingredientsText,
        required this.novaGroup,
        required this.nutriments,
        required this.nutriscoreGrade,
        required this.productName,
        required this.quantity,
    });

    final List<String> allergensTags;
    final String brands;
    final List<String> categoriesTags;
    final String ecoscoreGrade;
    final String imageUrl;
    final String ingredientsText;
    final num novaGroup;
    final Nutriments? nutriments;
    final String nutriscoreGrade;
    final String productName;
    final String quantity;

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
            allergensTags: json["allergens_tags"] == null ? [] : List<String>.from(json["allergens_tags"]!.map((x) => x)),
            brands: json["brands"] ?? "",
            categoriesTags: json["categories_tags"] == null ? [] : List<String>.from(json["categories_tags"]!.map((x) => x)),
            ecoscoreGrade: json["ecoscore_grade"] ?? "",
            imageUrl: json["image_url"] ?? "",
            ingredientsText: json["ingredients_text"] ?? "",
            novaGroup: json["nova_group"] ?? 0,
            nutriments: json["nutriments"] == null ? null : Nutriments.fromJson(json["nutriments"]),
            nutriscoreGrade: json["nutriscore_grade"] ?? "",
            productName: json["product_name"] ?? "",
            quantity: json["quantity"] ?? "",
        );
    }

}

class Nutriments {
    Nutriments({
        required this.carbohydrates,
        required this.carbohydrates100G,
        required this.carbohydratesServing,
        required this.carbohydratesUnit,
        required this.carbohydratesValue,
        required this.energy,
        required this.energyKcal,
        required this.energyKcal100G,
        required this.energyKcalServing,
        required this.energyKcalUnit,
        required this.energyKcalValue,
        required this.energyKcalValueComputed,
        required this.energyKj,
        required this.energyKj100G,
        required this.energyKjServing,
        required this.energyKjUnit,
        required this.energyKjValue,
        required this.energyKjValueComputed,
        required this.energy100G,
        required this.energyServing,
        required this.energyUnit,
        required this.energyValue,
        required this.fat,
        required this.fat100G,
        required this.fatServing,
        required this.fatUnit,
        required this.fatValue,
        required this.fiberModifier,
        required this.fruitsVegetablesLegumesEstimateFromIngredients100G,
        required this.fruitsVegetablesLegumesEstimateFromIngredientsServing,
        required this.fruitsVegetablesNutsEstimateFromIngredients100G,
        required this.fruitsVegetablesNutsEstimateFromIngredientsServing,
        required this.novaGroup,
        required this.novaGroup100G,
        required this.novaGroupServing,
        required this.nutritionScoreFr,
        required this.nutritionScoreFr100G,
        required this.proteins,
        required this.proteins100G,
        required this.proteinsServing,
        required this.proteinsUnit,
        required this.proteinsValue,
        required this.salt,
        required this.salt100G,
        required this.saltServing,
        required this.saltUnit,
        required this.saltValue,
        required this.saturatedFat,
        required this.saturatedFat100G,
        required this.saturatedFatServing,
        required this.saturatedFatUnit,
        required this.saturatedFatValue,
        required this.sodium,
        required this.sodium100G,
        required this.sodiumServing,
        required this.sodiumUnit,
        required this.sodiumValue,
        required this.sugars,
        required this.sugars100G,
        required this.sugarsServing,
        required this.sugarsUnit,
        required this.sugarsValue,
    });

    final num carbohydrates;
    final num carbohydrates100G;
    final num carbohydratesServing;
    final String carbohydratesUnit;
    final num carbohydratesValue;
    final num energy;
    final num energyKcal;
    final num energyKcal100G;
    final num energyKcalServing;
    final String energyKcalUnit;
    final num energyKcalValue;
    final num energyKcalValueComputed;
    final num energyKj;
    final num energyKj100G;
    final num energyKjServing;
    final String energyKjUnit;
    final num energyKjValue;
    final num energyKjValueComputed;
    final num energy100G;
    final num energyServing;
    final String energyUnit;
    final num energyValue;
    final num fat;
    final num fat100G;
    final num fatServing;
    final String fatUnit;
    final num fatValue;
    final String fiberModifier;
    final num fruitsVegetablesLegumesEstimateFromIngredients100G;
    final num fruitsVegetablesLegumesEstimateFromIngredientsServing;
    final num fruitsVegetablesNutsEstimateFromIngredients100G;
    final num fruitsVegetablesNutsEstimateFromIngredientsServing;
    final num novaGroup;
    final num novaGroup100G;
    final num novaGroupServing;
    final num nutritionScoreFr;
    final num nutritionScoreFr100G;
    final num proteins;
    final num proteins100G;
    final num proteinsServing;
    final String proteinsUnit;
    final num proteinsValue;
    final num salt;
    final num salt100G;
    final num saltServing;
    final String saltUnit;
    final num saltValue;
    final num saturatedFat;
    final num saturatedFat100G;
    final num saturatedFatServing;
    final String saturatedFatUnit;
    final num saturatedFatValue;
    final num sodium;
    final num sodium100G;
    final num sodiumServing;
    final String sodiumUnit;
    final num sodiumValue;
    final num sugars;
    final num sugars100G;
    final num sugarsServing;
    final String sugarsUnit;
    final num sugarsValue;

    factory Nutriments.fromJson(Map<String, dynamic> json){ 
        return Nutriments(
            carbohydrates: json["carbohydrates"] ?? 0,
            carbohydrates100G: json["carbohydrates_100g"] ?? 0,
            carbohydratesServing: json["carbohydrates_serving"] ?? 0,
            carbohydratesUnit: json["carbohydrates_unit"] ?? "",
            carbohydratesValue: json["carbohydrates_value"] ?? 0,
            energy: json["energy"] ?? 0,
            energyKcal: json["energy-kcal"] ?? 0,
            energyKcal100G: json["energy-kcal_100g"] ?? 0,
            energyKcalServing: json["energy-kcal_serving"] ?? 0,
            energyKcalUnit: json["energy-kcal_unit"] ?? "",
            energyKcalValue: json["energy-kcal_value"] ?? 0,
            energyKcalValueComputed: json["energy-kcal_value_computed"] ?? 0,
            energyKj: json["energy-kj"] ?? 0,
            energyKj100G: json["energy-kj_100g"] ?? 0,
            energyKjServing: json["energy-kj_serving"] ?? 0,
            energyKjUnit: json["energy-kj_unit"] ?? "",
            energyKjValue: json["energy-kj_value"] ?? 0,
            energyKjValueComputed: json["energy-kj_value_computed"] ?? 0,
            energy100G: json["energy_100g"] ?? 0,
            energyServing: json["energy_serving"] ?? 0,
            energyUnit: json["energy_unit"] ?? "",
            energyValue: json["energy_value"] ?? 0,
            fat: json["fat"] ?? 0,
            fat100G: json["fat_100g"] ?? 0,
            fatServing: json["fat_serving"] ?? 0,
            fatUnit: json["fat_unit"] ?? "",
            fatValue: json["fat_value"] ?? 0,
            fiberModifier: json["fiber_modifier"] ?? "",
            fruitsVegetablesLegumesEstimateFromIngredients100G: json["fruits-vegetables-legumes-estimate-from-ingredients_100g"] ?? 0,
            fruitsVegetablesLegumesEstimateFromIngredientsServing: json["fruits-vegetables-legumes-estimate-from-ingredients_serving"] ?? 0,
            fruitsVegetablesNutsEstimateFromIngredients100G: json["fruits-vegetables-nuts-estimate-from-ingredients_100g"] ?? 0,
            fruitsVegetablesNutsEstimateFromIngredientsServing: json["fruits-vegetables-nuts-estimate-from-ingredients_serving"] ?? 0,
            novaGroup: json["nova-group"] ?? 0,
            novaGroup100G: json["nova-group_100g"] ?? 0,
            novaGroupServing: json["nova-group_serving"] ?? 0,
            nutritionScoreFr: json["nutrition-score-fr"] ?? 0,
            nutritionScoreFr100G: json["nutrition-score-fr_100g"] ?? 0,
            proteins: json["proteins"] ?? 0,
            proteins100G: json["proteins_100g"] ?? 0,
            proteinsServing: json["proteins_serving"] ?? 0,
            proteinsUnit: json["proteins_unit"] ?? "",
            proteinsValue: json["proteins_value"] ?? 0,
            salt: json["salt"] ?? 0,
            salt100G: json["salt_100g"] ?? 0,
            saltServing: json["salt_serving"] ?? 0,
            saltUnit: json["salt_unit"] ?? "",
            saltValue: json["salt_value"] ?? 0,
            saturatedFat: json["saturated-fat"] ?? 0,
            saturatedFat100G: json["saturated-fat_100g"] ?? 0,
            saturatedFatServing: json["saturated-fat_serving"] ?? 0,
            saturatedFatUnit: json["saturated-fat_unit"] ?? "",
            saturatedFatValue: json["saturated-fat_value"] ?? 0,
            sodium: json["sodium"] ?? 0,
            sodium100G: json["sodium_100g"] ?? 0,
            sodiumServing: json["sodium_serving"] ?? 0,
            sodiumUnit: json["sodium_unit"] ?? "",
            sodiumValue: json["sodium_value"] ?? 0,
            sugars: json["sugars"] ?? 0,
            sugars100G: json["sugars_100g"] ?? 0,
            sugarsServing: json["sugars_serving"] ?? 0,
            sugarsUnit: json["sugars_unit"] ?? "",
            sugarsValue: json["sugars_value"] ?? 0,
        );
    }

}
