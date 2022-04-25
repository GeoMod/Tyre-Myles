//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI
import CoreData

struct EditTireView: View {
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var model: CoreDataModel
//	@EnvironmentObject var vm: TyreViewModel

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var name = ""
	@State private var installMilage: Double = 0
	@State private var removalMilage: Double = 0
	@State private var seasonType: SeasonType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage

	@FocusState private var fieldIsFocused: Bool

	let currentTire: TireEntity

	var body: some View {
		ScrollView {

			VStack {
				Text("Edit Tyre")
					.font(.largeTitle)
				TextField(currentTire.name ?? "Name", text: $name, prompt: Text("Name"))
					.textFieldStyle(.roundedBorder)
				Picker("Season", selection: $seasonType) {
					Text("Summer")
						.tag(SeasonType.summer)
					Text("All Season")
						.tag(SeasonType.allSeason)
					Text("Winter")
						.tag(SeasonType.winter)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Text("Enter Date Values")
					.font(.headline)
					.padding()
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

				Picker("Wheel Status", selection: $tireStatus) {
					Text("On Vehicle").tag(TireStatus.onVehicle)
					Text("In Storage").tag(TireStatus.inStorage)
				}.pickerStyle(.segmented)
					.padding(.vertical)

				DatePicker("Removal Date", selection: $removalDate, in: installDate..., displayedComponents: .date)
					.opacity(tireStatus == .onVehicle ? 0.25 : 1.0)
					.disabled(tireStatus == .onVehicle)

				Text("Enter Mileage Values")
					.font(.headline)
					.padding()

				Group {
					TextField("Installation Mileage", value: $installMilage, format: .number)
					TextField("Removal Mileage", value: $removalMilage, format: .number)
				}
				.keyboardType(.numberPad)
				.textFieldStyle(.roundedBorder)

				HStack {
					Button(role: .cancel) {
						dismiss()
					} label: {
						Text("Cancel")
							.foregroundColor(.red)
					}.buttonStyle(.automatic)

					Button {
						saveEdit()
					} label: {
						Text("Save")
							.foregroundColor(.white)
					}
					.buttonStyle(.borderedProminent)
					.disabled(removalMilage == 0 && tireStatus == .inStorage)
					// Disabled to prevent poor UX logic.
					.padding()
					.alert("Mileage Entry Error", isPresented: $model.isShowingAlert) {
						Button(role: .cancel) {
							removalMilage = 0
						} label: {
							Text("OK")
						}
					} message: {
						Text(ErrorMessage.negativeNumber)
					}
				}

			}
			.padding()
			.onAppear {
				loadInitialValues()
			}

		} // End ScrollView

	}

	private func loadInitialValues() {
		// TODO: Move to ViewModel?
		guard let loadedName = currentTire.name else { return }
		guard let loadedInstallDate = currentTire.installDate else { return }
		guard let loadedRemovalDate = currentTire.removalDate else { return }
		guard let loadedTireSeason = SeasonType(rawValue: currentTire.seasonType!) else { return }
		let loadedInstallMilage = currentTire.installMiles
		let loadedRemovalMilage = currentTire.removalMiles

		name = loadedName
		seasonType = loadedTireSeason
		tireStatus = loadingTire(status: currentTire.isInStorage)
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = loadedInstallMilage
		removalMilage = loadedRemovalMilage
	}

	private func saveEdit() {
		// TODO: Move to ViewModel?
		currentTire.name = name
		currentTire.seasonType = seasonType.rawValue
		currentTire.isInStorage = editingTire(status: tireStatus)
		currentTire.installDate = installDate
		currentTire.removalDate = removalDate
		currentTire.installMiles = installMilage
		currentTire.removalMiles = removalMilage

		model.updateCurrentTire(with: currentTire)

		// Dismiss View
		dismiss()
	}

	private func loadingTire(status: Bool) -> TireStatus {
		// To set value of Picker when loading Edit View.
		switch status {
			case true:
				return .inStorage
			case false:
				return .onVehicle
		}
	}

	private func editingTire(status: TireStatus) -> Bool {
		switch status {
			case .onVehicle:
				return false
			case .inStorage:
				return true
		}
	}



}

#if DEBUG
struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		Text("Test View")
    }
}
#endif
