//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct AddTireView: View {
	enum Field {
		case name
		case install
		case removal
	}

	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: DataModel

	@State private var name = ""
	@State private var seasonType: TireType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installMiles = ""
	@State private var removalMiles = ""

	@State private var isShowingAlert = false

	@FocusState private var focusedField: Field?
	@FocusState private var mileageIsFocused: Bool

	// Save button outline.
	let linearGradient = LinearGradient(gradient: Gradient(colors: [.gray, .white, .gray]), startPoint: .top, endPoint: .bottom)


	var body: some View {
		ScrollView {

			VStack {
				Picker("Season", selection: $seasonType) {
					Text("Summer")
						.tag(TireType.summer)
					Text("All Season")
						.tag(TireType.allSeason)
					Text("Winter")
						.tag(TireType.winter)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Group {
					TextField("Tire Name", text: $name)
						.focused($focusedField, equals: .name)
						.keyboardType(.alphabet)
						.submitLabel(.next)
						.padding(.top, 10)
					TextField("Install Mileage", text: $installMiles)
						.focused($focusedField, equals: .install)
						.focused($mileageIsFocused)
						.keyboardType(.numberPad)
//						.submitLabel(.next)
					TextField("Removal Mileage (Optional)", text: $removalMiles)
						.focused($mileageIsFocused)
//						.focused($focusedField, equals: .removal)
						.keyboardType(.numberPad)
//						.submitLabel(.done)
				}
				.textFieldStyle(.roundedBorder)
				.padding([.leading, .trailing])

				HStack {
					Button {
						checkLogicalMileageValues(install: installMiles, removal: removalMiles)
					} label: {
						Text("done")
							.foregroundColor(.blue)
							.padding(.leading)
					}
					.alert("Mileage Entry Error", isPresented: $isShowingAlert) {
						Button(role: .cancel) {
							removalMiles = ""
						} label: {
							Text("OK")
						}

					}
					Spacer()
				}

				Group {
					Text("Enter Date Values")
						.font(.title2)
						.padding(.top, 40)
					DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

					Picker("Wheel Status", selection: $tireStatus) {
						Text("On Vehicle").tag(TireStatus.onVehicle)
						Text("In Storage").tag(TireStatus.inStorage)
					}
					.pickerStyle(.segmented)
					.padding(.vertical)

					if tireStatus == .inStorage {
						DatePicker(selection: $removalDate, in: installDate..., displayedComponents: .date) { Text("Removal Date") }
					}
				}.padding(.horizontal)

				Spacer()

				SaveButton
			}

		}// End of ScrollView
		.navigationBarTitle(Text("Add New Tire"))

		.onSubmit {
			// move text focus to next field upon entry.
			switch focusedField {
				case .name:
					focusedField = .install
				case .install:
					// not used as of 11/23/21 but reserving logic for possible future use.
					focusedField = .removal
				case .removal:
					focusedField = nil
				case .none:
					focusedField = nil
			}
		}


	}


	private func checkLogicalMileageValues(install: String, removal: String) {
		// removal mileage cannot be greater than 0 but less than installation mileage.
		guard let convertedInstall = Int(install) else { return }
		guard let convertedRemoval = Int(removal) else {
			// No value was given for removal. Acceptable since tires may be on vehicle.
			// Dismiss keyboard
			mileageIsFocused = false
			return
		}

		let result = convertedRemoval - convertedInstall

		if result < 0 {
			// a negative mileage value has resulted.
			// trigger alert
			isShowingAlert = true
			return
		} else {
			mileageIsFocused = false
		}
	}

	private var SaveButton: some View {
		Button {
			save()
		} label: {
			Capsule()
				.stroke(linearGradient, lineWidth: 2)
				.frame(height: 50)
				.overlay(Text("Save")
							.font(.title.bold())
							.foregroundColor(.primary)
				)
		}
		.padding()
		.disabled(name.isEmpty)
		.opacity(name.isEmpty ? 0.25 : 1.0)
	}

	private func save() {
		dataModel.saveTireProfileWith(name: name, season: seasonType, status: tireStatus, installMiles: installMiles,
									  removalMiles: removalMiles, installDate: installDate,
									  removallDate: removalDate)

		dismiss()
	}

	private func cancel() {
		dismiss()
	}

}


#if DEBUG
struct NewTireView_Previews: PreviewProvider {

    static var previews: some View {
		AddTireView()
			.preferredColorScheme(.light)
    }
}
#endif
