
## Installation

Run `bundle` to install the `rspec` gem.

## Execution

* To run the tests, execute `rspec -f d`

* To run the program, execute `./main.rb input/sample_1.txt`

## Notes

* Medical related terms take precedence over food terms and book terms, and book terms over food terms.

* There are 3 key service classes (with their corresponding rspec tests): ParseInputService, ClassifyProductTypeService, and ComputeTotalForLineItemService.

* There are 2 more service classes (that rely on the above ones) used to produce the output.

* The program entry point is the main.rb file, which is executable.

* `ClassifyProductTypeService` accepts parameters to customize the terms that are taken into account when determining a given product typology. Such terms are hardcoced on `ComputeReceiptInfoService`'s `#product_classifier`.

